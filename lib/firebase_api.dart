import 'dart:convert';

import 'package:background_notification/main.dart';
import 'package:background_notification/screens/notifications_screens.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';


import 'package:flutter_local_notifications/flutter_local_notifications.dart';




Future<void> handleBackgroundMessage(RemoteMessage message) async{

if (kDebugMode) {
  print("The title is ${message.notification!.title.toString()}");
}
print("The body is ${message.notification!.body}");
print("The payloads is ${message.data}");

}





// handle the message 





class FirebaseApi{

final _localNotifications=FlutterLocalNotificationsPlugin();
// 
final _chanaleAndroid= AndroidNotificationChannel (
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
 
);






void handleMessage(RemoteMessage? message){
  if(message==null) return;


  navigatorKey.currentState?.pushNamed(
    NotificationsScreens.routes,
    arguments: message,

  );
  
  }

  Future initPushNotifications() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

// for init message 
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // for background case
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // background handler
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) async{
    final notification=message.notification;
      if(notification==null) return;

       
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _chanaleAndroid.id,
              _chanaleAndroid.name,
              channelDescription: _chanaleAndroid.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap())
        );
      
    });

  }


// init local notification methoods

// Future initLocalNotificationsMethods() async{
//   const androidSettings=AndroidInitializationSettings('@drawable/ic_launcher');
//   final iosSettings=IOSInitializationSettings();
//   final settings=InitializationSettings(
//     android: androidSettings,
//     iOS: iosSettings,

//   );
//   await _localNotifications.initialize(
//     settings,
//     onDidReceiveBackgroundNotificationResponse: (payload) async{
//       if(payload==null) return;
//       final message=RemoteMessage.fromMap(jsonDecode(payload) as Map<String,dynamic>);
//       handleMessage(message);
//     }
//   );
  
// }

Future<void> initLocalNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  // Updated iOS settings (now called Darwin)
  const darwinSettings = DarwinInitializationSettings();

  const settings = InitializationSettings(
    android: androidSettings,
    iOS: darwinSettings,
  );

  await _localNotifications.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      final payload = response.payload;
      if (payload == null) return;

      final message = RemoteMessage.fromMap(
        jsonDecode(payload) as Map<String, dynamic>,
      );
      handleMessage(message);
    },
     
  );

  final plateform= _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await plateform?.createNotificationChannel(_chanaleAndroid);
}



  

final _firebasemessaging = FirebaseMessaging.instance;



Future<void> initNotifications() async{
await _firebasemessaging.requestPermission();
final token=await _firebasemessaging.getToken();
print("Token is $token");
initPushNotifications();
initLocalNotifications();
}




// local push notification for flutter forground notifications 






































}