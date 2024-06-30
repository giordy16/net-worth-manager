import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:net_worth_manager/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "database"));
    return ObjectBox._create(store);
  }

  static Future<void> importDatabase(File database) async {
    final docsDir = await getApplicationDocumentsDirectory();
    String databasePath = p.join(docsDir.path, "database", "data.mdb");
    File databaseData = File(databasePath);
    await databaseData.writeAsBytes(await database.readAsBytes());
  }

  static Future<Uint8List> getDBData() async {
    final docsDir = await getApplicationDocumentsDirectory();
    String databasePath = p.join(docsDir.path, "database", "data.mdb");
    return await File(databasePath).readAsBytes();
  }

}
