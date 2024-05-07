import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';

Future<bool?> showYesNoBottomSheet(BuildContext context, String message) async {
  ThemeData theme = Theme.of(context);
  return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(Dimensions.l),
          width: double.infinity,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(message),
            SizedBox(height: Dimensions.xl),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.cardCorner))),
                      ),
                      onPressed: () {
                        context.pop(false);
                      },
                      child: Center(
                        child: Text(
                          'No',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.m),
                Expanded(
                  child: Container(
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            theme.colorScheme.secondary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.cardCorner))),
                      ),
                      onPressed: () {
                        context.pop(true);
                      },
                      child: Center(
                        child: Text(
                          'Yes',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: theme.colorScheme.onSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.xl)
          ]),
        );
      });
}
