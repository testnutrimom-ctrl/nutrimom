import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'nutrimom_channel',
    'NutriMom Notifications',
    description: 'Notifications for meal and water reminders',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    // Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings);

    // Create notification channel
await _localNotifications
        .resolvePlatformSpecificImplementation
            <AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  static Future<void> showWaterReminder({bool isHungarian = false}) async {
    await _localNotifications.show(
      1,
      isHungarian ? '💧 Ideje inni!' : '💧 Time to drink!',
      isHungarian
          ? 'Ne felejts el vizet inni! Maradj hidratált.'
          : 'Don\'t forget to drink water! Stay hydrated.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  static Future<void> showMealReminder({bool isHungarian = false}) async {
    await _localNotifications.show(
      2,
      isHungarian ? '🍽️ Étkezési emlékeztető' : '🍽️ Meal Reminder',
      isHungarian
          ? 'Ideje rögzíteni az étkezésedet!'
          : 'Time to log your meal!',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}