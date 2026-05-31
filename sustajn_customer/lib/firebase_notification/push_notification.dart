import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';



class FirebasePushNotification{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //for notification request
  void requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      Get.snackbar(
        'Notification permission denied',
        'pease allow notification to receive updates.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Future.delayed(const Duration(seconds: 2), (){
        // AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
      debugPrint('User declined or has not accepted permission');
    }
  }

  // get token
  Future<String> getDeviceToken() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    String? token = await messaging.getToken();
    print("token => $token");
    return token!;
  }

  // init
  void initLocalNotification(BuildContext context, RemoteMessage message) async{
    var androidInitSetting =
    const AndroidInitializationSettings("@mipmap/ic_launcher");

    var initializationSetting = InitializationSettings(android: androidInitSetting);

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  // firebase init(foreground State)
/*  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message){
      Utils.printLog(message.data!);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if(kDebugMode){
        print("Notification title: ${notification!.title}");
        print("Notification title: ${notification.body}");
      }
      // for android
      if(Platform.isAndroid){
        initLocalNotification(context, message);
        // handleMessage(context, message);
        showNotification(message);
      }
      // for IOS
      if(Platform.isIOS){
        iosForgroundMessage();
      }
    });
  }*/
  //function to show notifications
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel
      (message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.high,
      showBadge: true,
      playSound: true,
    );
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "Channel Description",
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: channel.sound,
    );

    //IoS Settings
    DarwinNotificationDetails darwinNotificationDetails =
    const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    //show notification
    Future.delayed(Duration.zero,
            (){
          _flutterLocalNotificationsPlugin.show(
            id: 0,
            title: message.notification!.title.toString(),
           body:  message.notification!.body.toString(),
           notificationDetails:  notificationDetails,
            payload: "My data",
          );
        });
  }
  // backgound and terminated
  Future<void> setupInteractMessage(BuildContext context) async{

    //background state
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message){
        handleMessage(context, message);
      },
    );
    //terminated state
    FirebaseMessaging.instance.getInitialMessage().
    then((RemoteMessage? message) {
      if(message != null && message.data.isNotEmpty){
        handleMessage(context, message);
      }
    }
    );
  }

  //handle message
  Future<void> handleMessage(
      BuildContext context, RemoteMessage message) async {
    // Navigator.push(context, MaterialPageRoute(
    //     builder: (context) =>  VisitorRegistrationScreen())
    // );
  }

  // ios message
  Future iosForgroundMessage() async{
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

}