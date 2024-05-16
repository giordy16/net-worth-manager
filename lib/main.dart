import 'package:flutter/material.dart';
import 'package:net_worth_manager/app_theme.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';
import 'package:net_worth_manager/utils/forex.dart';
import 'app_routes.dart';
import 'domain/database/objectbox.dart';

late ObjectBox objectbox;

Map<String, double> currencyChange = {};

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  await initApp();

  runApp(const App());
}

Future<void> initApp() async {
  objectbox.initIfEmpty();
  await objectbox.syncAssetPrices();
  await fetchForexExchange();
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
