import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/notification/local_notification_provider.dart';

class NotificationIcon extends StatelessWidget {
  final bool label;

  const NotificationIcon({super.key, this.label = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalNotificationProvider>(
      builder: (context, provider, child) {
        final icon = Icon(
          provider.isDailyNotificationEnabled
              ? Icons.notifications_active
              : Icons.notifications_off,
        );
        final text = Text(
          provider.isDailyNotificationEnabled ? 'Enabled' : 'Disabled',
        );

        return InkWell(
          onTap: provider.toggleDailyNotification,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                icon,
                if (label) ...[
                  const SizedBox(width: 8),
                  text,
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
