import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';

import '../../../i18n/strings.g.dart';
import '../../widgets/base_components/app_bottom_fab.dart';
import '../firebase_contacts/firebase_contacts_screen.dart';

class SoonAvailableScreen extends StatelessWidget {
  static String path = "/SoonAvailableScreen";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.soon_available),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AppBottomFab(
        text: t.suggest_feature,
        onTap: () => context.push(FirebaseContactsScreen.path,
            extra: FirebaseScreenType.suggestions),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
          child: ListView(
            children: [
              SizedBox(height: 8),
              Text(
                t.soon_available_message,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              ...t.soon_available_task.map((feature) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("\u2022 ", style: theme.textTheme.bodyMedium),
                            Expanded(
                                child: Text(feature,
                                    style: theme.textTheme.bodyMedium))
                          ],
                        )
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}
