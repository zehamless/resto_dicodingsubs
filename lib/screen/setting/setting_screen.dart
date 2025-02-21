import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/notification/local_notification_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.restaurant),
            SizedBox(width: 8),
            Text('RestoDicodingSubs'),
          ],
        ),
      ),
      body: Consumer<LocalNotificationProvider>(
        builder: (context, localNotificationProvider, child) {
          return ListView(
            children: [
              ListTile(
                title: const Text('Daily Reminder Notification'),
                subtitle: const Text('Enable or disable notification'),
                trailing: Switch(
                  value: localNotificationProvider.isDailyNotificationEnabled,
                  onChanged: (value) {
                    localNotificationProvider.toggleDailyNotification();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
