import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo_impl.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/ui/scaffold_with_bottom_navigation.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_params.dart';
import 'package:net_worth_manager/ui/screens/firebase_contacts/firebase_contacts_screen.dart';
import 'package:net_worth_manager/ui/screens/manage_categories/manage_categories.dart';
import 'package:net_worth_manager/ui/screens/soon_available/soon_available_screen.dart';
import 'package:net_worth_manager/ui/widgets/app_divider.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app_dimensions.dart';
import '../../../i18n/strings.g.dart';
import '../../../models/obox/currency_obox.dart';
import '../../../objectbox.g.dart';
import '../../../utils/enum/fetch_forex_type.dart';
import '../../widgets/modal/loading_overlay.dart';
import '../../widgets/modal/user_message.dart';
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

      await GetIt.I<Store>()
          .syncForexPrices(fetchType: FMPFetchType.mainCurrencyChange);
      await NetWorthRepoImpl().updateNetWorth();

      ScaffoldWithBottomNavigation.updateScreens();

      UserMessage.showMessage(context, t.main_currency_changed);
      LoadingOverlay.of(context).hide();
      setState(() {});
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
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.screenMargin),
              child: Text(
                t.settings,
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
                    Text(t.main_currency, style: theme.textTheme.bodyLarge),
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
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.screenMargin),
              child: AppDivider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.xxs),
              child: IconButton(
                onPressed: () => context.push(ImportExportScreen.path),
                icon: Row(
                  children: [
                    Text(t.import_export, style: theme.textTheme.bodyLarge),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, size: 14)
                  ],
                ),
              ),
            ),
            SizedBox(height: Dimensions.l),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.screenMargin),
              child: Text(
                t.assets_categories,
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
                    Text(t.hidden_asset, style: theme.textTheme.bodyLarge),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, size: 14)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.screenMargin),
              child: AppDivider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.xxs),
              child: IconButton(
                onPressed: () => context.push(ManageCategories.path),
                icon: Row(
                  children: [
                    Text(t.manage_categories, style: theme.textTheme.bodyLarge),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, size: 14)
                  ],
                ),
              ),
            ),
            SizedBox(height: Dimensions.l),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.screenMargin),
              child: Text(
                t.feedback,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.xxs),
              child: IconButton(
                onPressed: () => context.push(FirebaseContactsScreen.path,
                    extra: FirebaseScreenType.reports),
                icon: Row(
                  children: [
                    Text(t.report_a_problem, style: theme.textTheme.bodyLarge),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, size: 14)
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //       horizontal: Dimensions.screenMargin),
            //   child: AppDivider(),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: Dimensions.xxs),
            //   child: IconButton(
            //     onPressed: () => context.push(FirebaseContactsScreen.path,
            //         extra: FirebaseScreenType.suggestions),
            //     icon: Row(
            //       children: [
            //         Text("Suggest a new feature",
            //             style: theme.textTheme.bodyLarge),
            //         Expanded(child: SizedBox()),
            //         Icon(Icons.arrow_forward_ios, size: 14)
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.screenMargin),
              child: AppDivider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.xxs),
              child: IconButton(
                onPressed: () => context.push(SoonAvailableScreen.path),
                icon: Row(
                  children: [
                    Text(t.soon_available, style: theme.textTheme.bodyLarge),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, size: 14)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.screenMargin),
              child: AppDivider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.xxs),
              child: IconButton(
                onPressed: () => context.push(FirebaseContactsScreen.path,
                    extra: FirebaseScreenType.contacts),
                icon: Row(
                  children: [
                    Text(t.contact_us, style: theme.textTheme.bodyLarge),
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
              "${t.app_version} $appVersion",
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: Dimensions.l,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                t.settings_disclaimer,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
