import 'package:flutter/material.dart';
import 'package:net_worth_manager/app_dimensions.dart';

class SoonAvailableScreen extends StatelessWidget {
  static String path = "/SoonAvailableScreen";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final features = [
      "Automatic backup",
      "Automatic management of shares due to share splits",
      "Widgets for home screen",
      "Bug fix, of course :)",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Soon available"),
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
