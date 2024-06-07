import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';

import '../../../app_dimensions.dart';
import '../../../models/obox/currency_obox.dart';
import '../../../objectbox.g.dart';
import '../currency_selection/currency_selection_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Currency currentMainCurrency = GetIt.I<Settings>().defaultCurrency.target!;

  Future<void> _onCurrencySelected(Currency selectedCurrency) async {
    if (selectedCurrency != currentMainCurrency) {
      // update new main currency

      currentMainCurrency = selectedCurrency;

      Settings settings = GetIt.I<Settings>();
      settings.defaultCurrency.target = selectedCurrency;
      GetIt.I<Store>().box<Settings>().put(settings);
      setState(() {});

      await objectbox.syncForexPrices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.screenMargin),
          child: ListView(
            children: [
              Material(
                child: InkWell(
                  onTap: () async {
                    Currency? c = await context.push(
                        CurrencySelectionScreen.route,
                        extra: currentMainCurrency) as Currency?;
                    if (c == null) return;
                    _onCurrencySelected(c);
                  },
                  child: Row(
                    children: [
                      Text("Main currency"),
                      Expanded(child: SizedBox()),
                      Text(currentMainCurrency.name)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
