import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:developer' as dev;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone data
    tz_data.initializeTimeZones();
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName as String));
    } catch (e) {
      dev.log("Error initializing timezone: $e");
      // Fallback to UTC if something goes wrong
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );

    // Handle notification when app is launched from terminated state
    final NotificationAppLaunchDetails? launchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
      _handleNotificationTap(launchDetails.notificationResponse?.payload);
    }
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null && (payload == 'morning' || payload == 'evening')) {
      // Use a slight delay to ensure the navigator is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        navigatorKey.currentState?.pushNamed(
          '/adhkar',
          arguments: {'type': payload},
        );
      });
    }
  }

  // To handle navigation without context, we can use a GlobalKey
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleDailyReminder({required int hour, required int minute}) async {
    await _notificationsPlugin.zonedSchedule(
      0,
      'Ramadan 365 🌿',
      'Don\'t forget your daily micro-worship! Click to see today\'s action.',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription: 'Daily reminder to check your worship action',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    dev.log("Daily reminder scheduled for $hour:$minute");
  }

  Future<void> scheduleMorningAdhkar({required int hour, required int minute}) async {
    await _notificationsPlugin.zonedSchedule(
      1,
      'أذكار الصباح ☀️',
      'حان وقت أذكار الصباح، اجعل يومك مباركاً بذكر الله.',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'morning_adhkar_channel',
          'أذكار الصباح',
          channelDescription: 'تنبيه بأذكار الصباح',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'morning',
    );
    dev.log("Morning Adhkar scheduled for $hour:$minute");
  }

  Future<void> scheduleEveningAdhkar({required int hour, required int minute}) async {
    await _notificationsPlugin.zonedSchedule(
      2,
      'أذكار المساء 🌙',
      'حان وقت أذكار المساء، اختم يومك بذكر الله.',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'evening_adhkar_channel',
          'أذكار المساء',
          channelDescription: 'تنبيه بأذكار المساء',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'evening',
    );
    dev.log("Evening Adhkar scheduled for $hour:$minute");
  }

  Future<void> cancelSpecific(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
