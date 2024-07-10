import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';

import '../../widgets/base_components/app_bottom_fab.dart';
import '../firebase_contacts/firebase_contacts_screen.dart';

class SoonAvailableScreen extends StatelessWidget {
  static String path = "/SoonAvailableScreen";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final features = [
      "Automatic backup",
      "Automatic management of shares due to share splits",
      "Automatic tracking for commodities",
      "Sorting of categories in home screen",
      "Home widgets for iPhone/Android",
      "Bug fixes, of course :)",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Soon available"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AppBottomFab(
        text: "Suggest a new feature",
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
                "This is what we are currently working on:",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              ...features.map((feature) => Column(
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
