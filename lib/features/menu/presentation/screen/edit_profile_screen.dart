import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/utils/custom_snack.dart';
import 'package:pawnav/features/account/presentations/cubit/profile_cubit.dart';
import 'package:pawnav/features/menu/presentation/cubit/edit_profile_cubit.dart';
import 'package:pawnav/features/menu/presentation/cubit/edit_profile_state.dart';
import 'package:pawnav/features/menu/presentation/widget/edit_profile_avatar_editor.dart';
import 'package:pawnav/features/menu/presentation/widget/edit_profile_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Scaffold(
      backgroundColor: AppColors.white4,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<EditProfileMenuCubit, EditProfileState>(
        //  SAVE BAŞARILI OLUNCA GERİ DÖN
        listenWhen: (prev, curr) {
          return prev is EditProfileLoaded &&
              curr is EditProfileLoaded &&
              prev.isSaving == true &&
              curr.isSaving == false &&
              curr.errorMessage == null;
        },
        listener: (context, state) async {
          // SUCCESS SNACKBAR
          AppSnackbar.success(context, "Profile updated successfully");

          //context.read<ProfileCubit>().loadProfile();

          // SnackBar görülsün diye küçük delay
          await Future.delayed(const Duration(milliseconds: 600));

          // GERİ DÖN
          if (context.mounted) {
            context.pop(true);
          }
        },

        builder: (context, state) {
          if (state is EditProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! EditProfileLoaded) {
            return const Center(child: Text('Something went wrong'));
          }

          final s = state;

          final bool canSave = s.isDirty && !s.isSaving && s.usernameAvailable;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 24),

                /// AVATAR
                EditProfileAvatarEditor(
                  photoUrl: s.profile.photoUrl,
                  onEdit: () => _showPhotoPickerSheet(context),
                ),

                const SizedBox(height: 32),

                /// FULL NAME
                EditProfileTextField(
                  label: 'Full Name',
                  initialValue: s.profile.name,
                  onChanged: context
                      .read<EditProfileMenuCubit>()
                      .editProfileNameChanged,
                ),

                const SizedBox(height: 20),

                /// USERNAME
                EditProfileTextField(
                  label: 'Username',
                  prefixText: '@',
                  initialValue: s.profile.username,
                  onChanged: context
                      .read<EditProfileMenuCubit>()
                      .editProfileUsernameChanged,
                ),

                ///  INLINE USERNAME ERROR
                if (s.errorMessage != null) ...[
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        s.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                /// EMAIL (READ ONLY)
                EditProfileTextField(
                  label: 'Email',
                  initialValue: s.profile.email,
                  enabled: false,
                  suffixIcon: Icons.lock_outline,
                  helperText: 'Email cannot be changed once verified.',
                ),

                const SizedBox(height: 28),

                /// MEMBER SINCE
                Text(
                  'Member since ${_formatDate(s.profile.createdAt)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                SizedBox(height: height * 0.05),

                /// SAVE BUTTON
                GestureDetector(
                  onTap: canSave
                      ? () {
                          context
                              .read<EditProfileMenuCubit>()
                              .editProfileSave();
                        }
                      : null,
                  child: Container(
                    width: width * 0.88,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      gradient: canSave
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF233E96),
                                Color(0xFF3C59C7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [
                                Colors.grey.shade400,
                                Colors.grey.shade300,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: s.isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Save Changes",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                /// CANCEL
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// DATE FORMAT
  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  /// PHOTO PICKER

  void _showPhotoPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// DRAG INDICATOR
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                /// TITLE
                const Text(
                  'Change profile photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                /// CAMERA
                _PhotoActionTile(
                  icon: Icons.camera_alt,
                  iconColor: const Color(0xFF233E96),
                  title: 'Take Photo',
                  onTap: () {
                    Navigator.pop(context);
                    context.read<EditProfileMenuCubit>().pickImageFromCamera();
                  },
                ),

                const SizedBox(height: 12),

                /// GALLERY
                _PhotoActionTile(
                  icon: Icons.photo_library,
                  iconColor: const Color(0xFF3C59C7),
                  title: 'Choose from Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    context.read<EditProfileMenuCubit>().pickImageFromGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PhotoActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _PhotoActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade100,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
