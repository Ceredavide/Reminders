import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// A service class to manage local notifications using the
/// `flutter_local_notifications` package.
class NotificationConfig {
  // Main plugin instance for handling notifications.
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Callback to handle notifications received while the app is running.
  static Future<void> onDidReceiveLocalNotification(
      NotificationResponse notificationResponse) async {
    // Add custom logic here to respond to the notification when tapped.
  }

  /// Initializes the notification plugin with platform-specific settings.
  static Future<void> init() async {
    // Android-specific initialization settings.
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    // iOS-specific initialization settings.
    const DarwinInitializationSettings iOSInitalizationSettings =
        DarwinInitializationSettings();

    // General initialization settings for all platforms.
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iOSInitalizationSettings);

    // Initialize the plugin with the specified settings and callback handlers.
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveLocalNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveLocalNotification,
    );

    // Request notification permissions specifically for Android.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Schedules a notification at a specific date and time.
  static Future<void> scheduleNotification(
      {required int notificationId,
      required String title,
      required String body,
      required DateTime scheduledDate}) async {
    // Define notification details for both Android and iOS platforms.
    const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName'),
        iOS: DarwinNotificationDetails());

    // Schedule the notification using the given date and time.
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(
          scheduledDate, tz.local), // Convert to the local time zone.
      notificationDetails,
      matchDateTimeComponents:
          DateTimeComponents.dateAndTime, // Match both date and time.
      androidScheduleMode:
          AndroidScheduleMode.exact, // Ensure precise scheduling on Android.
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
