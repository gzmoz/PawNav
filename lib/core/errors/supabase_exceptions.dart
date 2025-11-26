import 'package:supabase_flutter/supabase_flutter.dart';
import 'failure.dart';
import 'error_messages.dart';

class SupabaseErrorHandler {
  static Failure handle(dynamic error) {
    // AUTH hataları
    if (error is AuthException) {
      final msg = error.message.toLowerCase();

      if (msg.contains('invalid login credentials')) {
        return AuthFailure(ErrorMessages.invalidCredentials);
      }
      if (msg.contains('email not confirmed')) {
        return AuthFailure(ErrorMessages.emailNotVerified);
      }
      return AuthFailure(error.message);
    }

    // STORAGE hataları
    if (error is StorageException) {
      return StorageFailure(ErrorMessages.uploadFailed);
    }

    // UNIQUE constraint (username, email vs.)
    if (error is PostgrestException && error.code == '23505') {
      if (error.message.contains('profiles_username_key')) {
        return AuthFailure(ErrorMessages.usernameTaken);
      }
    }

    // Bilinmeyen
    return UnknownFailure(ErrorMessages.unknown);
  }
}
