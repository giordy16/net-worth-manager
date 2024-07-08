import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:net_worth_manager/app_dimensions.dart';

class AppBottomFab extends StatelessWidget {
  String text;
  Function() onTap;
  bool outlinedStyle;
  bool enable;

  AppBottomFab({
    super.key,
    required this.text,
    required this.onTap,
    this.outlinedStyle = false,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.m),
      child: ElevatedButton(
        style: outlinedStyle
            ? ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        side: BorderSide(
                            color: theme.colorScheme.primary, width: 2),
                        borderRadius:
                            BorderRadius.circular(Dimensions.cardCorner))),
              )
            : ButtonStyle(
                backgroundColor: MaterialStateProperty.all(enable
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.secondary.withOpacity(0.3)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.cardCorner))),
              ),
        onPressed: onTap,
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
                color: outlinedStyle
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSecondary),
          ),
        ),
      ),
    );
  }
}
