import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/utils/custom_snack.dart';
import 'package:pawnav/features/account/presentations/widgets/AccountMenuComponent.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginSecurityPage extends StatelessWidget {
  const LoginSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    final user = Supabase.instance.client.auth.currentUser;
    final isSocialLogin =
        user?.appMetadata['provider'] != 'email';



    return Scaffold(
      backgroundColor: AppColors.white4,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Login & Security",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: width * 0.05,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 50,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.03,
            ),
            child: Column(
              children: [
                /// ACCOUNT ACCESS
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ACCOUNT ACCESS",
                      style: TextStyle(
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: width * 0.02,
                        vertical: height * 0.02,
                      ),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          AccountMenuComponent(
                            icon: Icons.lock_outline,
                            title: 'Change Password',
                            onTap: () {
                              context.push('/change-password');
                            },
                          ),
                          AccountMenuComponent(
                            icon: Icons.email_outlined,
                            title: 'E-mail',
                            onTap: () {
                              context.push('/email-address');
                            },
                          ),

                          /*AccountMenuComponent(
                            icon: Icons.email_outlined,
                            title: 'Email Address',
                            onTap: () {
                              context.push('/email-address');
                            },
                          ),*/

                        ],
                      ),
                    ),
                  ],
                ),

                /// SESSIONS
                // Padding(
                //   padding: EdgeInsets.only(top: height * 0.02),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         "SESSIONS",
                //         style: TextStyle(
                //           fontSize: width * 0.035,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.grey,
                //         ),
                //       ),
                //       Container(
                //         padding: EdgeInsetsDirectional.symmetric(
                //           horizontal: width * 0.02,
                //           vertical: height * 0.02,
                //         ),
                //         margin: const EdgeInsets.only(top: 8),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //         child: Column(
                //           children: [
                //             AccountMenuComponent(
                //               icon: Icons.devices_outlined,
                //               title: 'Active Sessions',
                //               onTap: () {
                //                 context.push('/active-sessions');
                //               },
                //             ),
                //
                //             AccountMenuComponent(
                //               icon: Icons.logout,
                //               title: 'Log out from all devices',
                //               onTap: () {
                //                 _confirmLogoutAll(context);
                //               },
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                /// RECOVERY
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "RECOVERY",
                        style: TextStyle(
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: width * 0.02,
                          vertical: height * 0.02,
                        ),
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            /*AccountMenuComponent(
                              icon: Icons.refresh,
                              title: 'Reset Password',
                              onTap: () {
                                context.push(
                                  '/menu-reset-password',
                                );

                              },
                            ),*/

                            AccountMenuComponent(
                              icon: Icons.delete_outline,
                              title: 'Delete Account',
                              onTap: () {
                                _confirmDeleteAccount(context);
                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.04),

                /// TRUST COPY (opsiyonel ama güzel)
                Text(
                  "PawNav never shares your personal data.\nYour account security matters to us.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.032,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



Future<void> _confirmDeleteAccount(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete account"),
        content: const Text(
          "This action is permanent. All your data will be deleted.\n\nAre you sure?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );

  if (confirmed == true) {
    await _deleteAccount(context);
  }
}
Future<void> _deleteAccount(BuildContext context) async {
  try {
    await Supabase.instance.client.rpc('delete_my_account');

    await Supabase.instance.client.auth.signOut();

    if (!context.mounted) return;
    context.go('/login');
  } catch (e) {
    AppSnackbar.error(context, "Account deletion failed.");
  }
}







