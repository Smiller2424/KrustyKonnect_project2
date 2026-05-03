import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _requestPermission();
    await saveDeviceToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'New Notification';
      final body = message.notification?.body ?? '';
      print('Foreground Notification $title - $body');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'Notification Opened';
      final body = message.notification?.body ?? '';
      print('Opened Notification $title - $body');
    });
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String?> saveDeviceToken() async {
    final token = await _messaging.getToken();

    if (token != null) {
      print('FCM Token: $token');
    }
    return token;
  }
}