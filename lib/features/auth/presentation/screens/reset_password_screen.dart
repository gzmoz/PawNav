import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final supabase = Supabase.instance.client;

  Future<void> updatePassword() async {
    final newPassword = passwordController.text.trim();

    final response = await supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password updated!")),
    );

    GoRouter.of(context).go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "New Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updatePassword,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
