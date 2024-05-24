import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';

Future<bool?> showDeleteConfirmSheet(
    BuildContext context, [String? message]) async {
  return await showYesNoBottomSheet(
      context, message ?? "Are you sure you want to delete this?");
}

Future<bool?> showYesNoBottomSheet(BuildContext context, String message) async {
  ThemeData theme = Theme.of(context);
  return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(Dimensions.l),
          width: double.infinity,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(message, textAlign: TextAlign.center,),
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
            SizedBox(height: MediaQuery.paddingOf(context).bottom)
          ]),
        );
      });
}

Future<Widget?> showSelectionSheet(
    BuildContext context, List<Widget> widgets) async {
  return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.l, horizontal: Dimensions.s),
          width: double.infinity,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Choose an option"),
            SizedBox(height: Dimensions.s),
            ...widgets.map((e) => Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.pop(e),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: e,
                    ),
                  ),
                )),
            SizedBox(height: MediaQuery.paddingOf(context).bottom)
          ]),
        );
      });
}
