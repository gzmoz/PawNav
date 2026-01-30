import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:pawnav/core/services/permission_service.dart';
import 'package:pawnav/features/menu/domain/usecases/edit_profile_check_username_usecase.dart';
import 'package:pawnav/features/menu/domain/usecases/edit_profile_get_usecase.dart';
import 'package:pawnav/features/menu/domain/usecases/edit_profile_update_usecase.dart';
import 'package:pawnav/features/menu/presentation/cubit/edit_profile_state.dart';

class EditProfileMenuCubit extends Cubit<EditProfileState> {
  final EditProfileGetUseCase getUseCase;
  final EditProfileUpdateUseCase updateUseCase;
  final EditProfileCheckUsernameUseCase checkUsernameUseCase;

  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();
  final PermissionService _permissionService = PermissionService();

  EditProfileMenuCubit(
      this.getUseCase,
      this.updateUseCase,
      this.checkUsernameUseCase,
      ) : super(EditProfileLoading());

  // ---------------------------------------------------------------------------
  // LOAD
  // ---------------------------------------------------------------------------

  Future<void> editProfileLoad() async {
    final profile = await getUseCase();
    emit(
      EditProfileLoaded(
        profile: profile,
        initialProfile: profile,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // IMAGE PICK & CROP
  // ---------------------------------------------------------------------------

  Future<CroppedFile?> _cropImage(String path) async {
    return ImageCropper().cropImage(
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

  Future<void> pickImageFromGallery() async {
    final hasPermission =
    await _permissionService.requestGalleryPermission();
    if (!hasPermission) return;

    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final cropped = await _cropImage(image.path);
    if (cropped == null) return;

    _setLocalPreview(cropped.path);
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

    _setLocalPreview(cropped.path);
  }

  /// ⚠️ SADECE PREVIEW
  void _setLocalPreview(String localPath) {
    final s = state as EditProfileLoaded;

    emit(
      s.copyWith(
        profile: s.profile.copyWith(photoUrl: localPath),
        isDirty: true,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TEXT CHANGES
  // ---------------------------------------------------------------------------

  void editProfileNameChanged(String name) {
    final s = state as EditProfileLoaded;

    emit(
      s.copyWith(
        profile: s.profile.copyWith(name: name),
        isDirty: true,
      ),
    );
  }

  Future<void> editProfileUsernameChanged(String username) async {
    final s = state as EditProfileLoaded;

    emit(
      s.copyWith(
        profile: s.profile.copyWith(username: username),
        isDirty: true,
        errorMessage: null,
      ),
    );

    if (username == s.initialProfile.username) {
      emit(s.copyWith(usernameAvailable: true));
      return;
    }

    final available = await checkUsernameUseCase.isUsernameAvailable(
      username: username,
      currentUserId: s.profile.id,
    );

    emit(
      s.copyWith(
        usernameAvailable: available,
        errorMessage: available ? null : 'This username is already taken',
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SAVE ( KRİTİK KISIM)
  // ---------------------------------------------------------------------------

  Future<void> editProfileSave() async {
    final s = state as EditProfileLoaded;
    emit(s.copyWith(isSaving: true, errorMessage: null));

    try {
      // USERNAME CHECK
      if (s.profile.username != s.initialProfile.username) {
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

      String finalPhotoUrl = s.profile.photoUrl ?? '';

      // 🔥 LOCAL IMAGE → STORAGE
      if (finalPhotoUrl.isNotEmpty && !finalPhotoUrl.startsWith('http')) {
        debugPrint('UPLOAD START');

        final file = File(finalPhotoUrl);
        final userId = s.profile.id;
        final fileName =
            '$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';

        await _supabase.storage
            .from('profile_photos')
            .upload(
          fileName,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

        debugPrint('UPLOAD DONE');

        finalPhotoUrl = _supabase.storage
            .from('profile_photos')
            .getPublicUrl(fileName);

        debugPrint('PUBLIC URL: $finalPhotoUrl');
      }

      debugPrint('DB UPDATE START');

      await updateUseCase(
        name: s.profile.name,
        username: s.profile.username,
        photoUrl: finalPhotoUrl,
      );

      debugPrint('DB UPDATE DONE');

      emit(
        s.copyWith(
          isSaving: false,
          isDirty: false,
          initialProfile: s.profile.copyWith(photoUrl: finalPhotoUrl),
          profile: s.profile.copyWith(photoUrl: finalPhotoUrl),
        ),
      );
    } catch (e, st) {
      debugPrint('❌ EDIT PROFILE ERROR: $e');
      debugPrint(st.toString());

      emit(
        s.copyWith(
          isSaving: false,
          errorMessage: 'Profile update failed. Please try again.',
        ),
      );
    }
  }

}
