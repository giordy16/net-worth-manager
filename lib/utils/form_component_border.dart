import 'package:flutter/material.dart';

import '../app_dimensions.dart';

OutlineInputBorder formErrorBorder(BuildContext context) {
  ThemeData theme = Theme.of(context);
  return OutlineInputBorder(
    borderRadius:
        const BorderRadius.all(Radius.circular(Dimensions.cardCorner)),
    borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
  );
}

OutlineInputBorder formFocusedBorder(BuildContext context) {
  ThemeData theme = Theme.of(context);
  return OutlineInputBorder(
    borderRadius:
        const BorderRadius.all(Radius.circular(Dimensions.cardCorner)),
    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
  );
}

OutlineInputBorder formEnabledBorder(BuildContext context) {
  ThemeData theme = Theme.of(context);
  return OutlineInputBorder(
    borderRadius:
        const BorderRadius.all(Radius.circular(Dimensions.cardCorner)),
    borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.0),
  );
}
