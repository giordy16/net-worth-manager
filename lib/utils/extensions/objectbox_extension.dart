import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/objectbox.g.dart';
import 'package:net_worth_manager/utils/enum/app_theme.dart';

import '../../domain/repository/stock/financial_modeling_repo.dart';
import '../../i18n/strings.g.dart';
import '../../models/obox/asset_time_value_obox.dart';
import '../currency_enum.dart';
import '../enum/fetch_forex_type.dart';

extension ObjectBoxExtension on Store {
  void init() {
    // fill Currency table with all currencies
    var currency = box<Currency>().getAll();
    if (currency.isEmpty) {
      for (var curr in CurrencyEnum.values) {
        var format = NumberFormat.simpleCurrency(
            locale: Platform.localeName, name: curr.name);
        box<Currency>().put(Currency(format.currencySymbol, curr.name));
      }
    }

    // init settings
    var settings = box<Settings>().getAll().firstOrNull;
    if (settings == null) {
      // set defaultCurrency to the currency based on the phone's location
      var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
      Currency currency = box<Currency>()
              .query(Currency_.name.equals(format.currencyName!))
              .build()
              .findFirst() ??
          box<Currency>().getAll().first;

      settings = Settings(showTutorial: true);
      settings.defaultCurrency.target = currency;
      box<Settings>().put(settings);
    }

    // if settings.showTutorial == null, put it to true
    if (settings.showTutorial == null) {
      settings.showTutorial = true;
      box<Settings>().put(settings);
    }

    // fill categories
    var categories = box<AssetCategory>().getAll();
    if (categories.isEmpty) {
      box<AssetCategory>().put(AssetCategory(t.bank_accounts));
      box<AssetCategory>().put(AssetCategory(t.vehicles));
      box<AssetCategory>().put(AssetCategory(t.real_estate));
      box<AssetCategory>().put(AssetCategory(t.debts));
      box<AssetCategory>().put(AssetCategory(t.other));
    }

    // check if there are the notSelectable asset categories: if not, add them
    if (categories
        .where((e) => e.marketAssetCategory == MarketAssetCategory.etfs)
        .isEmpty) {
      final category = AssetCategory("ETFs", userCanSelect: false, order: 0);
      category.setMarketAssetCategory(MarketAssetCategory.etfs);

      box<AssetCategory>().put(category);
    }
    if (categories
        .where((e) => e.marketAssetCategory == MarketAssetCategory.stocks)
        .isEmpty) {
      final category = AssetCategory(t.stocks, userCanSelect: false, order: 1);
      category.setMarketAssetCategory(MarketAssetCategory.stocks);
      box<AssetCategory>().put(category);
    }
    if (categories
        .where((e) => e.marketAssetCategory == MarketAssetCategory.commodities)
        .isEmpty) {
      final category =
          AssetCategory(t.commodities, userCanSelect: false, order: 2);
      category.setMarketAssetCategory(MarketAssetCategory.commodities);
      box<AssetCategory>().put(category);
    }
    if (categories
        .where((e) => e.marketAssetCategory == MarketAssetCategory.crypto)
        .isEmpty) {
      final category = AssetCategory("Crypto", userCanSelect: false, order: 3);
      category.setMarketAssetCategory(MarketAssetCategory.crypto);
      box<AssetCategory>().put(category);
    }
  }

  Future<void> syncAssetPrices() async {
    final repo = FinancialModelingRepoImpl();
    var marketInfos = box<MarketInfo>().getAll();
    for (var info in marketInfos) {
      repo.fetchPriceHistoryBySymbol(
        info,
        fetchType: FMPFetchType.appStart,
      );
    }
  }

  Future<void> syncForexPrices({
    String? currencyToFetch,
    required FMPFetchType fetchType,
    DateTime? startFetchDate,
  }) async {
    final repo = FinancialModelingRepoImpl();
    String mainCurrencySymbol =
        GetIt.instance<Settings>().defaultCurrency.target!.name;

    Set<String> assetCurrencies = GetIt.instance<Store>()
        .box<AssetTimeValue>()
        .getAll()
        .map((e) => e.currency.target!.name)
        .toSet();

    assetCurrencies.addAll(GetIt.instance<Store>()
        .box<MarketInfo>()
        .getAll()
        .map((e) => e.currency)
        .toSet());

    if (currencyToFetch != null) {
      assetCurrencies.add(currencyToFetch);
    }

    assetCurrencies.remove(mainCurrencySymbol);

    for (String currency in assetCurrencies) {
      await repo.fetchForexChange(
        currency,
        fetchType: fetchType,
        startFetchDate: startFetchDate,
      );
    }
  }
}
