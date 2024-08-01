import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';

import '../../../i18n/strings.g.dart';

Future<bool?> showDeleteConfirmSheet(BuildContext context,
    [String? message]) async {
  return await showYesNoBottomSheet(
      context, message ?? t.delete_confirmation_default);
}

Future<bool?> showOkOnlyBottomSheet(BuildContext context, String message,
    {String? imageAboveMessage}) async {
  ThemeData theme = Theme.of(context);
  return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(Dimensions.l),
            width: double.infinity,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (imageAboveMessage != null) ...[
                SvgPicture.asset(
                  imageAboveMessage,
                  height: 50,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                const SizedBox(height: Dimensions.m),
              ],
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.xl),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(theme.colorScheme.onSurface),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.cardCorner))),
                  ),
                  onPressed: () {
                    context.pop(true);
                  },
                  child: Center(
                    child: Text(
                      'Ok',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: theme.colorScheme.onSecondary),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom)
            ]),
          ),
        );
      });
}

Future<bool?> showYesNoBottomSheet(
  BuildContext context,
  String message, {
  bool isDismissible = true,
  Widget? widgetAboveSelection,
}) async {
  ThemeData theme = Theme.of(context);
  return await showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(Dimensions.l),
          width: double.infinity,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            if (widgetAboveSelection != null) ...[
              const SizedBox(height: Dimensions.m),
              widgetAboveSelection
            ],
            const SizedBox(height: Dimensions.l),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        shape:
                            WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.cardCorner))),
                      ),
                      onPressed: () {
                        context.pop(false);
                      },
                      child: Center(
                        child: Text(
                          t.no,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.m),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            theme.colorScheme.onSurface),
                        shape:
                            WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.cardCorner))),
                      ),
                      onPressed: () {
                        context.pop(true);
                      },
                      child: Center(
                        child: Text(
                          t.yes,
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
            Text(t.choose_an_option),
            const SizedBox(height: Dimensions.s),
            ...widgets.map((e) => Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.pop(e),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: e,
                    ),
                  ),
                )),
            SizedBox(height: MediaQuery.paddingOf(context).bottom)
          ]),
        );
      });
}
