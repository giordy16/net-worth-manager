import 'package:flutter/material.dart';

import '../../utils/TextStyles.dart';

class OverviewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OverviewPageState();
}

class OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Card(
                  color: Theme.of(context).colorScheme.surface,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Il tuo patrimonio',
                          style: normalBoldTextTS(),
                        ),
                        Text(
                          '€xxxxxxx',
                          style: normalTextTS(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
