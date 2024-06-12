import 'package:flutter/material.dart';

import '../../../app_dimensions.dart';

class ImportInvestmentsScreen extends StatefulWidget {
  static String route = "/ImportInvestmentsScreen";

  @override
  State<StatefulWidget> createState() => _ImportInvestmentsScreenState();
}

class _ImportInvestmentsScreenState extends State<ImportInvestmentsScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Import"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.screenMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Import your investments",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Dimensions.xs,),
            Text("Choose from which platform you want to import data")
          ],
        ),
      ),
    );
  }
}
