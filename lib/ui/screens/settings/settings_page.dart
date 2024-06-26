import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo_impl.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_params.dart';
import 'package:net_worth_manager/ui/widgets/app_divider.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app_dimensions.dart';
import '../../../models/obox/currency_obox.dart';
import '../../../objectbox.g.dart';
import '../../widgets/modal/loading_overlay.dart';
import '../currency_selection/currency_selection_screen.dart';
import '../excluded_asset/excluded_asset_screen.dart';
import '../import_export/import_export_screen.dart';

class SettingsScreen extends StatefulWidget {
  static String route = "/SettingsScreen";

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

      await GetIt.I<Store>().syncForexPrices();
      await NetWorthRepoImpl().updateNetWorth();

      LoadingOverlay.of(context).hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: Dimensions.s),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
              child: Text(
                "Settings",
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.xxs),
              child: IconButton(
                onPressed: () async {
                  context.push(CurrencySelectionScreen.route,
                      extra: CurrencySelectionParams(
                        selectedCurrency: currentMainCurrency,
                        onCurrencySelected: _onCurrencySelected,
                      ));
                },
                icon: Row(
                  children: [
                    Text("Main currency", style: theme.textTheme.bodyLarge),
                    Expanded(child: SizedBox()),
                    Text(currentMainCurrency.name,
                        style: theme.textTheme.bodyLarge),
                    SizedBox(width: Dimensions.s),
                    Icon(Icons.arrow_forward_ios, size: 14)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
              child: AppDivider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.xxs),
              child: IconButton(
                onPressed: () => context.push(ImportExportScreen.path),
                icon: Row(
                  children: [
                    Text("Import/Export", style: theme.textTheme.bodyLarge),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, size: 14)
                  ],
                ),
              ),
            ),
            SizedBox(height: Dimensions.l),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
              child: Text(
                "Net worth",
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.xxs),
              child: IconButton(
                onPressed: () {
                  context.push(HiddenAssetScreen.path);
                },
                icon: Row(
                  children: [
                    Text("Hidden assets", style: theme.textTheme.bodyLarge),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, size: 14)
                  ],
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
    );
  }
}
