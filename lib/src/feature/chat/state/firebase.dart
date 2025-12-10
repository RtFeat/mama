import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class FirebaseMessageStore {
  final MessagesStore store;
  FirebaseMessageStore({required this.store});

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Запрос разрешений (важно для iOS!)
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await firebaseMessaging.setAutoInitEnabled(true);

    // Настройка локальных уведомлений
    await _initLocalNotifications();

    // Обработка входящих сообщений в фоне
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.info("Foreground message: ${message.notification?.title}");

      logger.info(message.toMap());

      _showNotification(message);
    });

    // Обработка кликов по пушу
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.info("Notification clicked! Data: ${message.data}");
      _handleMessageClick(message);
    });

    // Если приложение запущено через пуш (после закрытия)
    RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      logger.info("App launched by notification: ${initialMessage.data}");
      _handleMessageClick(initialMessage);
    }
  }

  Future<void> _initLocalNotifications() async {
    var androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosSettings = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Local notification clicked: ${response.payload}");
        // Можно добавить логику обработки клика
      },
    );
  }

  void _showNotification(RemoteMessage message) async {
    var androidDetails = const AndroidNotificationDetails(
      'mama_chat_messages',
      'Chat Messages',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      message.notification?.title ?? 'Без заголовка',
      message.notification?.body ?? 'Без текста',
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  void _handleMessageClick(RemoteMessage message) {
    // Здесь можно обработать клики и перейти на нужный экран
    print("Handling message click: ${message.data}");
  }
}
