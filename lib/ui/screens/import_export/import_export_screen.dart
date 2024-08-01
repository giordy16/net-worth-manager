import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/ui/widgets/modal/user_message.dart';
import 'package:net_worth_manager/utils/extensions/context_extensions.dart';

import '../../../app_dimensions.dart';
import '../../../domain/database/objectbox.dart';
import '../../../i18n/strings.g.dart';
import '../../../main.dart';
import '../../../models/obox/settings_obox.dart';
import '../../../objectbox.g.dart';
import '../../scaffold_with_bottom_navigation.dart';
import '../../widgets/modal/bottom_sheet.dart';
import '../../widgets/modal/loading_overlay.dart';
import '../add_selection/component/add_selection_item.dart';
import 'package:path/path.dart' as p;

class ImportExportScreen extends StatelessWidget {
  static String path = "/ImportExportScreen";

  const ImportExportScreen({super.key});

  Future<void> exportDB(BuildContext context) async {
    try {
      var dbData = await ObjectBox.getDBData();
      String? outputPath = await FilePicker.platform.saveFile(
          dialogTitle: t.import_dialog_title,
          fileName: 'data.mdb',
          bytes: dbData);

      if (outputPath != null) {
        UserMessage.showMessage(context, t.import_successful);
      }
    } catch (e) {}
  }

  Future<void> importDB(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        LoadingOverlay.of(context).show();
        var yes = await showYesNoBottomSheet(
          context,
          t.import_disclaimer,
        );
        if (yes == true) {
          if (p.extension(result.files.single.path!) != ".mdb") {
            UserMessage.showMessage(context, t.import_file_not_supported);
            LoadingOverlay.of(context).hide();
            return;
          }

          File file = File(result.files.single.path!);

          GetIt.I<Store>().close();

          GetIt.I.unregister(instance: GetIt.I<Store>());
          GetIt.I.unregister(instance: GetIt.I<Settings>());
          ScaffoldWithBottomNavigation.unregisterScreenStates();

          await ObjectBox.importDatabase(file);
          await initApp();
          LoadingOverlay.of(context).hide();

          context.clearStackAndReplace(ScaffoldWithBottomNavigation.path);
        } else {
          LoadingOverlay.of(context).hide();
        }
      }
    } catch (e) {
      LoadingOverlay.of(context).hide();
      print(e);
      UserMessage.showMessage(context, t.import_error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.import_export),
        surfaceTintColor: Theme.of(context).colorScheme.surface,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.screenMargin),
          child: ListView(
            children: [
              AddSelectionItem(
                t.export_title,
                t.export_subtitle,
                () => exportDB(context),
              ),
              const SizedBox(height: Dimensions.m),
              AddSelectionItem(
                t.import_title,
                t.import_subtitle,
                () => importDB(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
