import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo_impl.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_params.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app_dimensions.dart';
import '../../../models/obox/currency_obox.dart';
import '../../../objectbox.g.dart';
import '../../widgets/modal/loading_overlay.dart';
import '../currency_selection/currency_selection_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Currency currentMainCurrency = GetIt.I<Settings>().defaultCurrency.target!;
  String appVersion = "x.x.x";

  bool showProgress = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      appVersion = (await PackageInfo.fromPlatform()).version;
      setState(() {});
    });

    super.initState();
  }

  Future<void> _onCurrencySelected(Currency selectedCurrency) async {
    if (selectedCurrency != currentMainCurrency) {
      // update new main currency
      LoadingOverlay.of(context).show();

      currentMainCurrency = selectedCurrency;

      Settings settings = GetIt.I<Settings>();
      settings.defaultCurrency.target = selectedCurrency;
      GetIt.I<Store>().box<Settings>().put(settings);
      setState(() {});

      await objectbox.syncForexPrices();
      await NetWorthRepoImpl().updateNetWorth();

      LoadingOverlay.of(context).hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.screenMargin),
          child: ListView(
            children: [
              Text(
                "Generals",
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Dimensions.m),
              Material(
                child: InkWell(
                  onTap: () async {
                    context.push(CurrencySelectionScreen.route,
                        extra: CurrencySelectionParams(
                          selectedCurrency: currentMainCurrency,
                          onCurrencySelected: _onCurrencySelected,
                        ));
                  },
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        Text("Main currency",
                            style: theme.textTheme.bodyLarge),
                        Expanded(child: SizedBox()),
                        Text(currentMainCurrency.name,
                            style: theme.textTheme.bodyLarge),
                        SizedBox(width: Dimensions.s),
                        Icon(Icons.arrow_forward_ios, size: 14)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: Dimensions.xl,
              ),
              Text(
                "App version: $appVersion",
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}