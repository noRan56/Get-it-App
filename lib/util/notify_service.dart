import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart' as initializeTimeZones;

class NotiService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) {
      return;
    }

    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (!status.isGranted) {
        print("Notification permission denied.");
        return;
      }
    }

    // final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    // tz.setLocalLocation(tz.getLocation(currentTimeZone));
    const initializationSettingsAndroid = AndroidInitializationSettings('icon');

    const initSettingIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initSettingIOS,
    );
    await notificationPlugin.initialize(initializationSettings);
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'your channel id', 'Daily Notificatin',
          channelDescription: 'Daily Notification 33',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          showWhen: true),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification(
      {int id = 0, String? title, String? body}) async {
    return await notificationPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  // Future<void> scheduleNotification({
  //   int id = 1,
  //   required String title,
  //   required String body,
  //   required int hour,
  //   required int minute,
  // }) async {
  //   final now = tz.TZDateTime.now(tz.local);

  //   var scheduleDate =
  //       tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

  //   await notificationPlugin.zonedSchedule(
  //       id, title, body, scheduleDate, const NotificationDetails(),
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //       matchDateTimeComponents: DateTimeComponents.time);
  // }

  Future<void> cancelAllNotification() async {
    await notificationPlugin.cancelAll();
  }
}
