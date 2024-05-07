import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:net_worth_manager/app_dimensions.dart';

class AppBottomFab extends StatelessWidget {
  String text;
  Function() onTap;

  AppBottomFab({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.m),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(theme.colorScheme.secondary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.cardCorner))),
        ),
        onPressed: onTap,
        child: Center(
          child: Text(
            'Save',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSecondary),
          ),
        ),
      ),
    );
  }
}
