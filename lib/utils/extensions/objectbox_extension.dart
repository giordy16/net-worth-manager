import 'dart:io';

import 'package:intl/intl.dart';
import 'package:net_worth_manager/domain/database/objectbox.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/objectbox.g.dart';

import '../../domain/repository/alphaVantage/AlphaVantageRepImp.dart';
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

    // set defaultCurrency to the currency based on the phone's location
    var settings = store.box<Settings>().getAll();
    if (settings.isEmpty) {
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
          .put(AssetCategory("Investments", userCanSelect: false));
    }
  }

  Future<void> syncPrices() async {
    final repo = AlphaVantageRepImp();
    var marketInfos = objectbox.store.box<MarketInfo>().getAll();
    for (var info in marketInfos) {
      var resp = await repo.getLastPriceBySymbol(info.symbol);
      if (resp != null) {
        info.value = resp;
        objectbox.store.box<MarketInfo>().put(info);
      }
    }
  }

}
