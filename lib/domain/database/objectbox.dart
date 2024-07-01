import 'dart:io';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ObjectBox {

  static Future<void> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final directoryPath = p.join(docsDir.path, "database");

    if (Store.isOpen(directoryPath)) {
      final store = Store.attach(getObjectBoxModel(), directoryPath);
      GetIt.I.registerSingleton<Store>(store);
    } else {
      final store = await openStore(directory: directoryPath);
      GetIt.I.registerSingleton<Store>(store);
    }
  }

  static Future<void> importDatabase(File database) async {
    final docsDir = await getApplicationDocumentsDirectory();
    String databasePath = p.join(docsDir.path, "database", "data.mdb");
    File databaseData = File(databasePath);
    await databaseData.writeAsBytes(await database.readAsBytes());

    await create();
  }

  static Future<Uint8List> getDBData() async {
    final docsDir = await getApplicationDocumentsDirectory();
    String databasePath = p.join(docsDir.path, "database", "data.mdb");
    return await File(databasePath).readAsBytes();
  }
}
