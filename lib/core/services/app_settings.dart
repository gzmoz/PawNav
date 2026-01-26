import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';

class SystemSettingsService {
  Future<void> openPermissions() async {
    await openAppSettings(); // permission_handler
  }

  Future<void> openNotifications() async {
    if (Platform.isAndroid) {
      // Android: direkt Notification settings
      AppSettings.openAppSettings(type: AppSettingsType.notification);
    } else {
      // iOS: yalnızca App Settings mümkün
      await openAppSettings();
    }
  }
}
