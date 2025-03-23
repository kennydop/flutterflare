import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/configs/app_config.dart';
import 'package:flutterflare/core/logger/logger.dart';
import 'package:flutterflare/core/router/app_router.dart';
import 'package:flutterflare/core/services/notification/toast_service.dart';
import 'package:flutterflare/core/services/notification/token_service.dart';
import 'package:flutterflare/firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

// Define notification channels
const String _mainChannelId = 'main_channel';
const String _mainChannelName = 'Default Channel';
const String _mainChannelDescription =
    'Default notification channel for app alerts';

// Android notification channel details
const AndroidNotificationDetails _androidNotificationDetails =
    AndroidNotificationDetails(
      _mainChannelId,
      _mainChannelName,
      channelDescription: _mainChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

// iOS notification channel details
const DarwinNotificationDetails _iosNotificationDetails =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

// Default notification details
const NotificationDetails _notificationDetails = NotificationDetails(
  android: _androidNotificationDetails,
  iOS: _iosNotificationDetails,
);

// Provider for the FCM token
@riverpod
Future<String?> fcmToken(FcmTokenRef ref) async {
  return await FirebaseMessaging.instance.getToken();
}

// Provider for the NotificationService
@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  final tokenService = ref.watch(tokenServiceProvider);
  return NotificationService(tokenService: tokenService, ref: ref);
}

// Background handler for FCM messages when the app is in the background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase for background handlers if needed
  await Firebase.initializeApp(
    name: AppConfig.environment.name,
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.i('Handling a background message: ${message.messageId}');
  // You can perform actions based on the notification here
}

// Service for handling push & local notifications using Firebase Cloud Messaging
class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final TokenService? _tokenService;
  final Ref _ref;

  bool _initialized = false;

  NotificationService({TokenService? tokenService, required Ref ref})
    : _tokenService = tokenService,
      _ref = ref;

  // Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final notificationSettings =
        await _firebaseMessaging.getNotificationSettings();

    if (notificationSettings.authorizationStatus !=
        AuthorizationStatus.authorized) {
      await _requestNotificationPermission();
    }
    // Initialize local notifications
    await _initializeLocalNotifications();

    // Handle incoming messages
    _setupForegroundMessageHandler();
    _setupMessageOpenedAppHandler();
    _setupInitialMessageHandler();

    // Set up token refresh listener
    _setupTokenRefreshListener();

    _initialized = true;
    logger.i('Notification service initialized');
  }

  // Setup a listener for FCM token refreshes
  void _setupTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      logger.i('FCM token refreshed: $newToken');

      // If token service is available, update the token
      if (_tokenService != null) {
        await _tokenService.updateToken(newToken);
      }
    });
  }

  // Request notification permissions
  Future<void> _requestNotificationPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    logger.i('User notification settings: ${settings.authorizationStatus}');

    // Enable provisional notifications for iOS 12+ (shows quietly and allows user to turn on full notifications)
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Initialize the local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@drawable/ic_launcher_foreground',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _createAndroidNotificationChannel();
    }
  }

  // Create the notification channel for Android
  Future<void> _createAndroidNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      _mainChannelId,
      _mainChannelName,
      description: _mainChannelDescription,
      importance: Importance.max,
      playSound: true,
      showBadge: true,
      enableLights: true,
      enableVibration: true,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  // Handle messages received while the app is in the foreground
  void _setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.i(
        'Got a message whilst in the foreground!\nMessage data: ${message.data}',
      );

      if (message.notification != null) {
        logger.i(
          'Message also contained a notification: ${message.notification}',
        );
        // Pass context to the Toast.showNotification method to enable navigation
        final navigatorKey = _ref.read(rootNavigatorKeyProvider);
        final context = navigatorKey.currentContext;
        Toast.showNotification(message, context: context);
      }
    });
  }

  // Handle when a user taps on a notification that opened the app
  void _setupMessageOpenedAppHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.i('A notification opened the app: ${message.data}');
      // Handle navigation or other actions based on notification
      _handleNotificationTap(message);
    });
  }

  // Handle initial message if app was terminated and opened via notification
  Future<void> _setupInitialMessageHandler() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      logger.i('App opened from terminated state via notification');
      // Handle navigation or other actions based on notification
      _handleNotificationTap(initialMessage);
    }
  }

  // Show a local notification for a received FCM message
  Future<void> _showForegroundLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      await _localNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        _notificationDetails,
        payload: jsonEncode(message.data),
      );
    }
  }

  // Get the FCM token for this device
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Delete the current FCM token
  Future<void> deleteToken() async {
    return await _firebaseMessaging.deleteToken();
  }

  // Subscribe to a topic for topic-based notifications
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    logger.i('Subscribed to topic: $topic');
  }

  // Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    logger.i('Unsubscribed from topic: $topic');
  }

  // Get Apple Push Notification service (APNs) token (iOS only)
  Future<String?> getAPNSToken() async {
    if (Platform.isIOS) {
      return await _firebaseMessaging.getAPNSToken();
    }
    return null;
  }

  // Handle when a user taps on a local notification
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.payload!);
        logger.i('Notification tapped with data: $data');
        // Handle navigation based on payload
        _handleNotificationNavigation(data);
      } catch (e) {
        logger.e('Error parsing notification payload: $e');
      }
    }
  }

  // Handle push notification tap
  void _handleNotificationTap(RemoteMessage message) {
    logger.i('Handling notification tap: ${message.data}');
    _handleNotificationNavigation(message.data);
  }

  // Public method to handle notification data from other sources
  // void handleNotificationData(Map<String, dynamic> data) {
  //   _handleNotificationNavigation(data);
  // }

  // Central method to handle navigation from notification data
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    if (data.isEmpty) {
      logger.i('No navigation data in notification');
      return;
    }

    try {
      // Get navigation context using the provider
      final rootNavigatorKey = _ref.read(rootNavigatorKeyProvider);
      final context = rootNavigatorKey.currentContext;
      if (context == null) {
        logger.e('Cannot navigate: no valid navigation context found');
        return;
      }

      // Extract route information from data
      String? route = data['route'];
      Map<String, dynamic>? params = _extractParams(data);

      if (route != null) {
        logger.i('Navigating to route: $route with params: $params');

        // Handle deep link based on the route
        if (route.startsWith('/')) {
          context.go(route, extra: params);
        } else {
          context.go('/$route', extra: params);
        }
      }
    } catch (e) {
      logger.e('Error navigating from notification: $e');
    }
  }

  // Extract route parameters from notification data
  Map<String, dynamic>? _extractParams(Map<String, dynamic> data) {
    // Remove the route key and use the rest as parameters
    final Map<String, dynamic> params = Map.from(data);
    params.remove('route');

    // If there are no other params, return null
    if (params.isEmpty) {
      return null;
    }

    return params;
  }
}
