import 'package:flutter/material.dart';
import 'package:net_worth_manager/app_dimensions.dart';

class AppBottomFab extends StatelessWidget {
  String text;
  Function() onTap;
  bool outlinedStyle;
  bool enable;
  double? horizontalMargin;
  double? cornerRadius;

  AppBottomFab(
      {super.key,
      required this.text,
      required this.onTap,
      this.outlinedStyle = false,
      this.enable = true,
      this.horizontalMargin,
      this.cornerRadius});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      height: 60,
      margin:
          EdgeInsets.symmetric(horizontal: horizontalMargin ?? Dimensions.s),
      child: ElevatedButton(
        style: outlinedStyle
            ? ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        side: BorderSide(
                            color: theme.colorScheme.onSurface, width: 2),
                        borderRadius: BorderRadius.circular(
                            cornerRadius ?? Dimensions.cardCorner))),
              )
            : ButtonStyle(
                backgroundColor: WidgetStateProperty.all(enable
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withOpacity(0.3)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            cornerRadius ?? Dimensions.cardCorner))),
              ),
        onPressed: onTap,
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
                color: outlinedStyle
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSecondary),
          ),
        ),
      ),
    );
  }
}
