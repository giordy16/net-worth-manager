import 'package:flutter/material.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/utils/fcm_notification.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../i18n/strings.g.dart';

class PushNotificationScreen extends StatefulWidget {
  static String route = "/PushNotificationScreen";

  @override
  State<StatefulWidget> createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen>
    with WidgetsBindingObserver {
  bool notificationGranted = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      notificationGranted = await Permission.notification.status.isGranted;
      setState(() {});
    });

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      notificationGranted = await Permission.notification.status.isGranted;
      setState(() {});
    });
  }

  Future<void> onNotificationChange(bool value) async {
    if (value) {
      if (!await Permission.notification.request().isGranted) {
        await openAppSettings();
      }
      setState(() {});
    } else {
      FcmNotification.deleteFCMToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.push_notification)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.monthly_reminder_title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        t.monthly_reminder_subtitle,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Switch(
                    value: notificationGranted, onChanged: onNotificationChange)
              ],
            )
          ],
        ),
      ),
    );
  }
}
