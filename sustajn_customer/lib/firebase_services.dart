import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustajn_customer/utils/utils.dart';
import 'constants/network_urls.dart';

class FirebaseServices {
  static final FirebaseServices _instance = FirebaseServices._internal();
  factory FirebaseServices() {
    Utils.getProfile();
    return _instance;
  }
  FirebaseServices._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  static const String _tokenKey = 'fcm_token';
  static const String _lastUpdateKey = 'fcm_token_last_update';
  static const int _updateIntervalDays = 1;

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      Utils.printLog('Firebase initialized successfully');

      await _initializeLocalNotifications();
      await _requestPermissions();
      await _setupForegroundNotificationHandler();
      await _setupBackgroundNotificationHandler();
      await _setupNotificationInteraction();
      await _getAndUpdateToken();
      _setupTokenRefreshListener();

      Utils.printLog('Firebase Services initialized successfully');
    } catch (e) {
      Utils.printLog('Firebase initialization error: $e');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<void> _requestPermissions() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      Utils.printLog('Notification permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        Utils.printLog('User granted notification permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        Utils.printLog('User granted provisional notification permission');
      } else {
        Utils.printLog('User declined notification permission');
      }
    } catch (e) {
      Utils.printLog('Permission request error: $e');
    }
  }

  Future<void> _getAndUpdateToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      Utils.printLog('FCM Token: $_fcmToken');

      if (_fcmToken != null) {
        await _checkAndUpdateTokenIfNeeded(_fcmToken!);
      }
    } catch (e) {
      Utils.printLog('Error getting FCM token: $e');
    }
  }

  Future<void> _checkAndUpdateTokenIfNeeded(String newToken) async {
    try {
      print("Firebase UserId :---- ${Utils.userId}");
      if (Utils.userId == null || Utils.userId! <= 0) {
        Utils.printLog('UserId is invalid. Token update skipped.');
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString(_tokenKey);
      final lastUpdateTimestamp = prefs.getInt(_lastUpdateKey);

      final now = DateTime.now().millisecondsSinceEpoch;
      bool shouldUpdate = false;

      if (savedToken == null || savedToken != newToken) {
        Utils.printLog('Token changed or not saved, updating...');
        shouldUpdate = true;
      } else if (lastUpdateTimestamp == null) {
        Utils.printLog('No last update timestamp, updating...');
        shouldUpdate = true;
      } else {
        final lastUpdate = DateTime.fromMillisecondsSinceEpoch(lastUpdateTimestamp);
        final daysSinceUpdate = DateTime.now().difference(lastUpdate).inDays;

        if (daysSinceUpdate >= _updateIntervalDays) {
          Utils.printLog('14 days passed, updating token...');
          shouldUpdate = true;
        } else {
          Utils.printLog('Token updated $daysSinceUpdate days ago, no update needed');
        }
      }

      if (shouldUpdate) {
        await _updateTokenToAPI(newToken);
        await prefs.setString(_tokenKey, newToken);
        await prefs.setInt(_lastUpdateKey, now);
        Utils.printLog('Token saved and updated successfully');
      }
    } catch (e) {
      Utils.printLog('Error checking/updating token: $e');
    }
  }

  Future<void> _updateTokenToAPI(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceToken = prefs.getString("token");
    try {
      Utils.printLog('Updating FCM token to API: $token');

      final String deviceType = Platform.isAndroid ? 'Android' : 'iOS';

      final response = await http.post(
        Uri.parse('${NetworkUrls.BASE_URL}notification/registerOrUpdateDeviceToken'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $deviceToken',
        },
        body: jsonEncode({
          'userId': Utils.userId,
          'deviceToken': token,
          'deviceType': deviceType,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.printLog('Token updated successfully on server');
        Utils.printLog('Response: ${response.body}');
      } else {
        Utils.printLog('Failed to update token on server: ${response.statusCode}');
        Utils.printLog('Response: ${response.body}');
      }
    } catch (e) {
      Utils.printLog('Error updating token to API: $e');
    }
  }

  void _setupTokenRefreshListener() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      Utils.printLog('FCM Token refreshed: $newToken');
      _fcmToken = newToken;
      _checkAndUpdateTokenIfNeeded(newToken);
    }).onError((error) {
      Utils.printLog('Token refresh error: $error');
    });
  }

  Future<void> _setupForegroundNotificationHandler() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Utils.printLog('Foreground message received: ${message.messageId}');
      _handleMessage(message, true);
    });
  }

  Future<void> _setupBackgroundNotificationHandler() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
  }

  Future<void> _setupNotificationInteraction() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Utils.printLog('Notification opened app: ${message.messageId}');
      _handleNotificationTap(message);
    });

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      Utils.printLog('App opened from terminated state: ${initialMessage.messageId}');
      _handleNotificationTap(initialMessage);
    }
  }

  void _handleMessage(RemoteMessage message, bool showNotification) {
    Utils.printLog('Message data: ${message.data}');
    Utils.printLog('Message notification: ${message.notification?.title}');

      _showLocalNotification(message);

  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final notification = message.data;

      if (notification != null) {
        const androidDetails = AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF064E3B),
        );

        const iosDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        const notificationDetails = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );

        await _localNotifications.show(
           notification.hashCode,
           notification['title'],
           notification['body'],
           notificationDetails,
          payload: message.data.toString(),
        );

        Utils.printLog('Local notification shown: ${notification['title']}');
      }
    } catch (e) {
      Utils.printLog('Error showing local notification: $e');
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    Utils.printLog('Notification tapped: ${message.data}');
  }

  void _onNotificationTapped(NotificationResponse response) {
    Utils.printLog('Local notification tapped: ${response.payload}');
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      Utils.printLog('Subscribed to topic: $topic');
    } catch (e) {
      Utils.printLog('Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      Utils.printLog('Unsubscribed from topic: $topic');
    } catch (e) {
      Utils.printLog('Error unsubscribing from topic: $e');
    }
  }

  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_lastUpdateKey);
      _fcmToken = null;
      Utils.printLog('FCM token deleted');
    } catch (e) {
      Utils.printLog('Error deleting token: $e');
    }
  }

  Future<void> forceTokenUpdate() async {
    try {
      await _firebaseMessaging.deleteToken();
      final newToken = await _firebaseMessaging.getToken();
      if (newToken != null) {
        await _updateTokenToAPI(newToken);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, newToken);
        await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
        _fcmToken = newToken;
        Utils.printLog('Token force updated: $newToken');
      }
    } catch (e) {
      Utils.printLog('Error forcing token update: $e');
    }
  }

  Future<Map<String, dynamic>> getTokenInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString(_tokenKey);
      final lastUpdateTimestamp = prefs.getInt(_lastUpdateKey);

      return {
        'currentToken': _fcmToken,
        'savedToken': savedToken,
        'lastUpdate': lastUpdateTimestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(lastUpdateTimestamp)
            : null,
        'daysSinceUpdate': lastUpdateTimestamp != null
            ? DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(lastUpdateTimestamp))
            .inDays
            : null,
      };
    } catch (e) {
      Utils.printLog('Error getting token info: $e');
      return {};
    }
  }
}

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message received: ${message.messageId}');
  print('Background message data: ${message.data}');
}