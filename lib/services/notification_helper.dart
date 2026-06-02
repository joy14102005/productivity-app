import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    tz.initializeTimeZones();
    await _plugin.initialize(const InitializationSettings(android: android, iOS: ios));
  }

  static Future<void> showNotification({required int id, required String title, required String body}) async {
    const android = AndroidNotificationDetails('focusflow_channel', 'FocusFlow', importance: Importance.max, priority: Priority.high);
    const ios = DarwinNotificationDetails();
    await _plugin.show(id, title, body, const NotificationDetails(android: android, iOS: ios));
  }

  static Future<void> scheduleNotification({required int id, required String title, required String body, required DateTime scheduledAt}) async {
    final android = AndroidNotificationDetails('focusflow_channel', 'FocusFlow', importance: Importance.max, priority: Priority.high);
    final ios = DarwinNotificationDetails();
  await _plugin.zonedSchedule(id, title, body, tz.TZDateTime.from(scheduledAt, tz.local), NotificationDetails(android: android, iOS: ios), uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle);
  }

  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}
