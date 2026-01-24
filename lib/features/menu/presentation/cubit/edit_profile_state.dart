import 'package:pawnav/features/menu/domain/entities/edit_profile_entity.dart';

abstract class EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileLoaded extends EditProfileState {
  final EditProfileEntity profile;
  final EditProfileEntity initialProfile;

  final bool isDirty;
  final bool isSaving;
  final bool usernameAvailable;
  final String? errorMessage;

  EditProfileLoaded({
    required this.profile,
    required this.initialProfile,
    this.isDirty = false,
    this.isSaving = false,
    this.usernameAvailable = true,
    this.errorMessage,
  });

  EditProfileLoaded copyWith({
    EditProfileEntity? profile,
    EditProfileEntity? initialProfile,
    bool? isDirty,
    bool? isSaving,
    bool? usernameAvailable,
    String? errorMessage,
  }) {
    return EditProfileLoaded(
      profile: profile ?? this.profile,
      initialProfile: initialProfile ?? this.initialProfile,
      isDirty: isDirty ?? this.isDirty,
      isSaving: isSaving ?? this.isSaving,
      usernameAvailable: usernameAvailable ?? this.usernameAvailable,
      errorMessage: errorMessage,
    );
  }
}


// class EditProfileLoaded extends EditProfileState {
//   final EditProfileEntity profile;
//   final bool isDirty;
//   final bool isSaving;
//   final String? errorMessage;
//   final EditProfileEntity initialProfile;
//
//
//   EditProfileLoaded( {
//     required this.profile,
//     this.isDirty = false,
//     this.isSaving = false,
//     this.errorMessage,
//     required this.initialProfile,
//   });
//
//   EditProfileLoaded copyWith({
//     EditProfileEntity? profile,
//     bool? isDirty,
//     bool? isSaving,
//     String? errorMessage,
//     EditProfileEntity? initialProfile,
//   }) {
//     return EditProfileLoaded(
//       profile: profile ?? this.profile,
//       isDirty: isDirty ?? this.isDirty,
//       isSaving: isSaving ?? this.isSaving,
//       errorMessage: errorMessage,
//       initialProfile: initialProfile ?? this.initialProfile,
//     );
//   }
//
//
// /*EditProfileLoaded copyWith({
//     EditProfileEntity? profile,
//     bool? isDirty,
//     bool? isSaving,
//   }) {
//     return EditProfileLoaded(
//       profile: profile ?? this.profile,
//       isDirty: isDirty ?? this.isDirty,
//       isSaving: isSaving ?? this.isSaving,
//     );
//   }*/
// }
