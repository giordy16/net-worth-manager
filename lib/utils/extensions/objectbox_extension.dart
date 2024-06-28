import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/domain/database/objectbox.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/objectbox.g.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';
import 'package:net_worth_manager/utils/forex.dart';

import '../../domain/repository/alphaVantage/alpha_vantage_repo.dart';
import '../../models/obox/asset_time_value_obox.dart';
import '../currency_enum.dart';

extension ObjectBoxExtension on ObjectBox {
  void initIfEmpty() {
    // fill Currency table with all currencies
    var currency = store.box<Currency>().getAll();
    if (currency.isEmpty) {
      for (var curr in CurrencyEnum.values) {
        var format = NumberFormat.simpleCurrency(
            locale: Platform.localeName, name: curr.name);
        store.box<Currency>().put(Currency(format.currencySymbol, curr.name));
      }
    }

    // init settings
    var settings = store.box<Settings>().getAll();
    if (settings.isEmpty) {
      // set defaultCurrency to the currency based on the phone's location
      var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
      Currency currency = store
              .box<Currency>()
              .query(Currency_.name.equals(format.currencyName!))
              .build()
              .findFirst() ??
          store.box<Currency>().getAll().first;

      Settings settings = Settings();
      settings.defaultCurrency.target = currency;
      store.box<Settings>().put(settings);
    }

    // insert category for investments
    var categories = store.box<AssetCategory>().getAll();
    if (categories.isEmpty) {
      store
          .box<AssetCategory>()
          .put(AssetCategory("ETFs / Stocks", userCanSelect: false));
    }
  }

  Future<void> syncAssetPrices() async {
    final repo = AlphaVantageRepImp();
    var marketInfos = objectbox.store.box<MarketInfo>().getAll();
    for (var info in marketInfos) {
      repo.fetchPriceHistoryBySymbol(info);
    }
  }

  Future<void> syncForexPrices({String? currencyToFetch}) async {
    final repo = AlphaVantageRepImp();
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
      await repo.fetchForexChange(currency);
    }
  }
}
