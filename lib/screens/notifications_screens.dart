import 'package:flutter/material.dart';

class NotificationsScreens extends StatelessWidget {
  const NotificationsScreens({super.key});

  static const routes="/notification-screen";

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments ;
    return Scaffold(
      appBar: AppBar(
       title: Text("Notification Screen"), 
      ),
      body: Column(
        children: [
          Text(message.toString()),
        ],
      ),
    );
  }
}