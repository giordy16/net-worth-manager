import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/objectbox.g.dart';

import '../../domain/repository/stock/financial_modeling_repo.dart';
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
      box<AssetCategory>().put(AssetCategory("Cash"));
      box<AssetCategory>().put(AssetCategory("Car"));
      box<AssetCategory>().put(AssetCategory("Debts"));
      box<AssetCategory>().put(AssetCategory("ETFs"));
      box<AssetCategory>().put(AssetCategory("Stocks"));
      box<AssetCategory>().put(AssetCategory("Crypto"));
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
