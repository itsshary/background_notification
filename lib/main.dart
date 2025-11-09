import 'package:background_notification/firebase_api.dart';
import 'package:background_notification/screens/home_screen.dart';
import 'package:background_notification/screens/notifications_screens.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


final navigatorKey=GlobalKey<NavigatorState>();
void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
   );
   await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      title: 'Background Notification Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      
      ), 
      home: const HomeScreen(), 
      navigatorKey: navigatorKey,
      routes: {
        NotificationsScreens.routes:(context) => const NotificationsScreens()
      },
    );
  }
}

