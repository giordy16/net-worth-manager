import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  double? height;

  AppDivider({this.height});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 1,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
    );
  }
}
