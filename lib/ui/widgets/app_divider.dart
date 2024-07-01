import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
    );
  }
}
