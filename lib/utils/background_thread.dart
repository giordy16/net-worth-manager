import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/objectbox.g.dart';
import '../main.dart';
import '../models/obox/settings_obox.dart';

Future<R> runInDifferentThread<R>(FutureOr<R> Function() computation) async {
  ByteData storeReference = objectbox.store.reference;

  var result = await Isolate.run(() async {
    Store store = Store.fromReference(getObjectBoxModel(), storeReference);
    GetIt.I.registerSingleton<Store>(store);
    GetIt.I.registerSingleton<Settings>(store.box<Settings>().getAll().first);

    return await computation();
  });

  return result;
}
