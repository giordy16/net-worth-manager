import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/app_theme.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo_impl.dart';
import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';
import 'package:objectbox/objectbox.dart';
import 'app_routes.dart';
import 'domain/database/objectbox.dart';

late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  await initApp();

  runApp(const App());
}

Future<void> initApp() async {
  objectbox.initIfEmpty();

  // register GetIt
  GetIt.I.registerSingleton<Store>(objectbox.store);
  GetIt.I.registerSingleton<Settings>(
      objectbox.store.box<Settings>().getAll().first);

  // objectbox.store.box<AssetHistoryTimeValue>().removeAll();

  await objectbox.syncForexPrices();
  await objectbox.syncAssetPrices();

  await NetWorthRepoImpl()
      .updateNetWorth(updateStartingDate: DateTime.now().keepOnlyYMD());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = MaterialTheme(Theme.of(context).textTheme);

    return MaterialApp.router(
        theme: theme.dark(),
        title: 'Net Worth Manager',
        debugShowCheckedModeBanner: false,
        routerConfig: appRoutes);
  }
}
