import 'package:flutter/material.dart';

class UserMessage {
  static void showMessage(BuildContext context, String message) {
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onPrimary)),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
