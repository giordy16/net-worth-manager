import 'package:flutter/material.dart';

import '../../../../app_dimensions.dart';

class AddSelectionItem extends StatelessWidget {
  String title;
  String subTitle;
  Function() onPress;

  AddSelectionItem(this.title, this.subTitle, this.onPress, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return OutlinedButton(
        style: ButtonStyle(
          alignment: Alignment.centerLeft,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.cardCorner))),
        ),
        onPressed: () {
          onPress();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(subTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary.withOpacity(0.6))),
            ],
          ),
        ));
  }
}
