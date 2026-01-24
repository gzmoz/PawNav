import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:pawnav/core/services/permission_service.dart';
import 'package:pawnav/features/menu/domain/entities/edit_profile_entity.dart';
import 'package:pawnav/features/menu/domain/usecases/edit_profile_check_username_usecase.dart';
import 'package:pawnav/features/menu/domain/usecases/edit_profile_get_usecase.dart';
import 'package:pawnav/features/menu/domain/usecases/edit_profile_update_usecase.dart';
import 'package:pawnav/features/menu/presentation/cubit/edit_profile_state.dart';

class EditProfileMenuCubit  extends Cubit<EditProfileState> {
  final EditProfileGetUseCase getUseCase;
  final EditProfileUpdateUseCase updateUseCase;
  final EditProfileCheckUsernameUseCase checkUsernameUseCase;

  EditProfileMenuCubit(
      this.getUseCase,
      this.updateUseCase,
      this.checkUsernameUseCase,
      ) : super(EditProfileLoading());

  Future<void> editProfileLoad() async {
    final profile = await getUseCase();
    emit(
      EditProfileLoaded(
        profile: profile,
        initialProfile: profile,
      ),
    );

    //emit(EditProfileLoaded(profile: profile));
  }

  Future<CroppedFile?> _cropImage(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 95,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Photo',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          lockAspectRatio: true,
          cropStyle: CropStyle.circle,
        ),
        IOSUiSettings(
          title: 'Crop Photo',
          aspectRatioLockEnabled: true,
        ),
      ],
    );
  }


  void editProfileNameChanged(String name) {
    final s = state as EditProfileLoaded;
    emit(s.copyWith(
      profile: EditProfileEntity(
        id: s.profile.id,
        name: name,
        username: s.profile.username,
        email: s.profile.email,
        photoUrl: s.profile.photoUrl,
        createdAt: s.profile.createdAt,
      ),
      isDirty: true,
    ));
  }

  Future<void> editProfileUsernameChanged(String username) async {
    final s = state as EditProfileLoaded;

    // Önce local update
    emit(
      s.copyWith(
        profile: s.profile.copyWith(username: username),
        isDirty: true,
        errorMessage: null,
      ),
    );

    // Eğer eski username ise → sorun yok
    if (username == s.initialProfile.username) {
      emit(
        (state as EditProfileLoaded).copyWith(usernameAvailable: true),
      );
      return;
    }

    // 🔎 Availability check
    final available = await checkUsernameUseCase.isUsernameAvailable(
      username: username,
      currentUserId: s.profile.id,
    );

    emit(
      (state as EditProfileLoaded).copyWith(
        usernameAvailable: available,
        errorMessage: available ? null : 'This username is already taken',
      ),
    );
  }


  Future<void> editProfileSave() async {
    final s = state as EditProfileLoaded;

    emit(s.copyWith(isSaving: true));

    // USERNAME DEĞİŞTİYSE KONTROL ET
    final isUsernameChanged =
        s.profile.username != s.initialProfile.username;

    if (isUsernameChanged) {
      final available = await checkUsernameUseCase.isUsernameAvailable(
        username: s.profile.username,
        currentUserId: s.profile.id,
      );

      if (!available) {
        emit(
          s.copyWith(
            isSaving: false,
            errorMessage: 'This username is already taken',
          ),
        );
        return;
      }
    }

    //  UPDATE
    await updateUseCase(
      name: s.profile.name,
      username: s.profile.username,
      photoUrl: s.profile.photoUrl,
    );

    emit(
      s.copyWith(
        isSaving: false,
        isDirty: false,
        initialProfile: s.profile,
      ),
    );
  }


  // Future<void> editProfileSave() async {
  //   final s = state as EditProfileLoaded;
  //   emit(s.copyWith(isSaving: true));
  //
  //   await updateUseCase(
  //     name: s.profile.name,
  //     username: s.profile.username,
  //     photoUrl: s.profile.photoUrl,
  //   );
  //
  //   emit(s.copyWith(isSaving: false, isDirty: false));
  // }

  final _picker = ImagePicker();
  final _permissionService = PermissionService();

  Future<void> pickImageFromGallery() async {
    final hasPermission =
    await _permissionService.requestGalleryPermission();
    if (!hasPermission) return;

    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final cropped = await _cropImage(image.path);
    if (cropped == null) return;

    _updateProfilePhoto(cropped.path);
  }


  Future<void> pickImageFromCamera() async {
    final hasPermission =
    await _permissionService.requestCameraPermission();
    if (!hasPermission) return;

    final XFile? image =
    await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final cropped = await _cropImage(image.path);
    if (cropped == null) return;

    _updateProfilePhoto(cropped.path);
  }


  void _updateProfilePhoto(String path) {
    final s = state as EditProfileLoaded;

    emit(s.copyWith(
      profile: s.profile.copyWith(
        photoUrl: path, // ŞİMDİLİK LOCAL PATH
      ),
      isDirty: true,
    ));
  }

}
