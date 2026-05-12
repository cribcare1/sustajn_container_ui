import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'constants/network_urls.dart';
import 'constants/string_utils.dart';
import 'utils/sharedpreference_utils.dart';
import 'utils/utility.dart';

class FirebaseServices {
  static final FirebaseServices _instance =
  FirebaseServices._internal();

  factory FirebaseServices() {
    Utils.getUserId();
    return _instance;
  }

  FirebaseServices._internal();

  final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin
  _localNotifications =
  FlutterLocalNotificationsPlugin();

  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  static const String _tokenKey = 'fcm_token';
  static const String _lastUpdateKey =
      'fcm_token_last_update';

  static const int _updateIntervalDays = 1;

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();

      Utils.printLog(
        'Firebase initialized successfully',
      );

      await _initializeLocalNotifications();

      await _requestPermissions();

      await _setupForegroundNotificationHandler();

      await _setupBackgroundNotificationHandler();

      await _setupNotificationInteraction();

      await _getAndUpdateToken();

      _setupTokenRefreshListener();

      Utils.printLog(
        'Firebase Services initialized successfully',
      );
    } catch (e) {
      Utils.printLog(
        'Firebase initialization error: $e',
      );
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse:
      _onNotificationTapped,

    );

    Utils.printLog(
      'Local notifications initialized',
    );
  }

  Future<void> _requestPermissions() async {
    try {
      NotificationSettings settings =
      await _firebaseMessaging
          .requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      Utils.printLog(
        'Notification permission status: '
            '${settings.authorizationStatus}',
      );
    } catch (e) {
      Utils.printLog(
        'Permission request error: $e',
      );
    }
  }

  Future<void> _getAndUpdateToken() async {
    try {
      _fcmToken =
      await _firebaseMessaging.getToken();

      Utils.printLog(
        'FCM Token: $_fcmToken',
      );

      if (_fcmToken != null &&
          _fcmToken!.isNotEmpty) {
        await _checkAndUpdateTokenIfNeeded(
          _fcmToken!,
        );
      }
    } catch (e) {
      Utils.printLog(
        'Error getting FCM token: $e',
      );
    }
  }

  Future<void> _checkAndUpdateTokenIfNeeded(
      String newToken) async {
    try {
      if (Utils.userId == null ||
          Utils.userId! <= 0) {
        Utils.printLog(
          'UserId invalid. Token update skipped.',
        );

        return;
      }

      final savedToken =
      await SharedPreferenceUtils
          .getStringValuesSF(
        _tokenKey,
      );

      final lastUpdateTimestamp =
      await SharedPreferenceUtils
          .getIntValuesSF(
        _lastUpdateKey,
      );

      final now =
          DateTime.now().millisecondsSinceEpoch;

      bool shouldUpdate = false;

      if (savedToken == null ||
          savedToken.isEmpty ||
          savedToken != newToken) {
        shouldUpdate = true;

        Utils.printLog(
          'Token changed, updating...',
        );
      } else if (lastUpdateTimestamp ==
          null ||
          lastUpdateTimestamp == -1) {
        shouldUpdate = true;

        Utils.printLog(
          'No last update timestamp',
        );
      } else {
        final lastUpdate =
        DateTime.fromMillisecondsSinceEpoch(
          lastUpdateTimestamp,
        );

        final daysSinceUpdate =
            DateTime.now()
                .difference(lastUpdate)
                .inDays;

        if (daysSinceUpdate >=
            _updateIntervalDays) {
          shouldUpdate = true;

          Utils.printLog(
            'Update interval reached',
          );
        }
      }

      if (shouldUpdate) {
        await _updateTokenToAPI(
          newToken,
        );

        await SharedPreferenceUtils
            .saveDataInSF(
          _tokenKey,
          newToken,
        );

        await SharedPreferenceUtils
            .saveDataInSF(
          _lastUpdateKey,
          now,
        );

        Utils.printLog(
          'Token updated successfully',
        );
      }
    } catch (e) {
      Utils.printLog(
        'Error checking token: $e',
      );
    }
  }

  Future<void> _updateTokenToAPI(
      String token) async {
    try {
      final jwtToken =
      await SharedPreferenceUtils
          .getStringValuesSF(
        Strings.JWT_TOKEN,
      );

      final String deviceType =
      Platform.isAndroid
          ? 'Android'
          : 'iOS';

      final response = await http.post(
        Uri.parse(
          '${NetworkUrls.BASE_URL}'
              'notification/registerOrUpdateDeviceToken',
        ),
        headers: {
          'Content-Type':
          'application/json',
          'Accept':
          'application/json',
          'Authorization':
          'Bearer $jwtToken',
        },
        body: jsonEncode({
          'userId': Utils.userId,
          'deviceToken': token,
          'deviceType': deviceType,
        }),
      );

      Utils.printLog(
        'FCM API BODY => ${jsonEncode({
          'userId': Utils.userId,
          'deviceToken': token,
          'deviceType': deviceType,
        })}',
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        Utils.printLog(
          'Token updated on server',
        );

        Utils.printLog(
          'Response => ${response.body}',
        );
      } else {
        Utils.printLog(
          'Failed token update: '
              '${response.statusCode}',
        );

        Utils.printLog(
          'Error Response => ${response.body}',
        );
      }
    } catch (e) {
      Utils.printLog(
        'API token update error: $e',
      );
    }
  }

  void _setupTokenRefreshListener() {
    _firebaseMessaging.onTokenRefresh.listen(
          (newToken) async {
        _fcmToken = newToken;

        Utils.printLog(
          'FCM Token refreshed => $newToken',
        );

        await _checkAndUpdateTokenIfNeeded(
          newToken,
        );
      },
      onError: (error) {
        Utils.printLog(
          'Token refresh error: $error',
        );
      },
    );
  }

  Future<void>
  _setupForegroundNotificationHandler() async {
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        Utils.printLog(
          'Foreground message received',
        );

        _handleMessage(
          message,
          true,
        );
      },
    );
  }

  Future<void>
  _setupBackgroundNotificationHandler() async {
    FirebaseMessaging.onBackgroundMessage(
      backgroundMessageHandler,
    );
  }

  Future<void>
  _setupNotificationInteraction() async {
    FirebaseMessaging.onMessageOpenedApp
        .listen(
          (RemoteMessage message) {
        _handleNotificationTap(
          message,
        );
      },
    );

    final initialMessage =
    await _firebaseMessaging
        .getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationTap(
        initialMessage,
      );
    }
  }

  void _handleMessage(
      RemoteMessage message,
      bool showNotification,
      ) {
    Utils.printLog(
      'Message data: ${message.data}',
    );

    Utils.printLog(
      'Message notification: '
          '${message.notification?.title}',
    );

    if (showNotification) {
      _showLocalNotification(
        message,
      );
    }
  }

  Future<void> _showLocalNotification(
      RemoteMessage message) async {
    try {
      final notification = message.data;

      const androidDetails =
      AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription:
        'Important notifications',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails =
      DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails =
      NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        id: notification.hashCode,
       title:  notification['title'] ?? '',
       body:  notification['body'] ?? '',
        notificationDetails: notificationDetails,
        payload: jsonEncode(
          message.data,
        ),
      );

      Utils.printLog(
        'Local notification shown',
      );
    } catch (e) {
      Utils.printLog(
        'Notification show error: $e',
      );
    }
  }

  void _handleNotificationTap(
      RemoteMessage message) {
    Utils.printLog(
      'Notification tapped: ${message.data}',
    );
  }

  void _onNotificationTapped(
      NotificationResponse response) {
    Utils.printLog(
      'Local notification tapped: '
          '${response.payload}',
    );
  }

  Future<void> subscribeToTopic(
      String topic) async {
    try {
      await _firebaseMessaging
          .subscribeToTopic(topic);

      Utils.printLog(
        'Subscribed to topic: $topic',
      );
    } catch (e) {
      Utils.printLog(
        'Subscribe topic error: $e',
      );
    }
  }

  Future<void> unsubscribeFromTopic(
      String topic) async {
    try {
      await _firebaseMessaging
          .unsubscribeFromTopic(topic);

      Utils.printLog(
        'Unsubscribed from topic: $topic',
      );
    } catch (e) {
      Utils.printLog(
        'Unsubscribe topic error: $e',
      );
    }
  }

  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging
          .deleteToken();

      await SharedPreferenceUtils
          .removeValueFromSF(
        _tokenKey,
      );

      await SharedPreferenceUtils
          .removeValueFromSF(
        _lastUpdateKey,
      );

      _fcmToken = null;

      Utils.printLog(
        'FCM token deleted',
      );
    } catch (e) {
      Utils.printLog(
        'Delete token error: $e',
      );
    }
  }

  Future<void> forceTokenUpdate() async {
    try {
      await _firebaseMessaging
          .deleteToken();

      final newToken =
      await _firebaseMessaging
          .getToken();

      if (newToken != null &&
          newToken.isNotEmpty) {
        await _updateTokenToAPI(
          newToken,
        );

        await SharedPreferenceUtils
            .saveDataInSF(
          _tokenKey,
          newToken,
        );

        await SharedPreferenceUtils
            .saveDataInSF(
          _lastUpdateKey,
          DateTime.now()
              .millisecondsSinceEpoch,
        );

        _fcmToken = newToken;

        Utils.printLog(
          'Token force updated',
        );
      }
    } catch (e) {
      Utils.printLog(
        'Force token update error: $e',
      );
    }
  }

  Future<Map<String, dynamic>>
  getTokenInfo() async {
    try {
      final savedToken =
      await SharedPreferenceUtils
          .getStringValuesSF(
        _tokenKey,
      );

      final lastUpdateTimestamp =
      await SharedPreferenceUtils
          .getIntValuesSF(
        _lastUpdateKey,
      );

      return {
        'currentToken': _fcmToken,
        'savedToken': savedToken,
        'lastUpdate':
        lastUpdateTimestamp != null &&
            lastUpdateTimestamp != -1
            ? DateTime
            .fromMillisecondsSinceEpoch(
          lastUpdateTimestamp,
        )
            : null,
      };
    } catch (e) {
      Utils.printLog(
        'Get token info error: $e',
      );

      return {};
    }
  }
}

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);

  const AndroidNotificationDetails androidDetails =
  AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    id:message.hashCode,
    title: message.data['title'],
    body: message.data['body'],
    notificationDetails: notificationDetails,
  );

  print('Background notification shown');
}