import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo_impl.dart';
import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:objectbox/objectbox.dart';
import '../../objectbox.g.dart';
import 'asset_category_obox.dart';

@Entity()
class Asset {
  @Id()
  int id = 0;

  String name;

  // flag to control if asset should be visible or not in the home
  bool? excludeFromNW;

  ToMany<AssetTimeValue> timeValues = ToMany<AssetTimeValue>();

  ToOne<AssetCategory> category = ToOne<AssetCategory>();

  ToOne<MarketInfo> marketInfo = ToOne<MarketInfo>();

  Asset(this.name);

  DateTime? getLastUpdateDate() {
    return getTimeValuesChronologicalOrder().lastOrNull?.date;
  }

  @override
  String toString() {
    return name;
  }

  /// Get current value at main currency
  ///
  /// for simple asset (marketInfo == null) the current value is just
  /// the last value inserted by the user.
  /// for market asset (marketInfo != null) the current value is the current
  /// market value multiplied by the total quantity.
  double getCurrentValue() {
    if (marketInfo.target == null) {
      // simple asset, just look the last value inserted by the user
      AssetTimeValue? lastTimeValue =
          getTimeValuesChronologicalOrder().lastOrNull;
      if (lastTimeValue == null) return 0;

      return lastTimeValue.value
          .atMainCurrency(fromCurrency: lastTimeValue.currency.target!.name);
    } else {
      // market asset, need to look to market value
      double value = GetIt.I<Store>()
              .box<AssetHistoryTimeValue>()
              .query(AssetHistoryTimeValue_.assetSymbol.equals(marketInfo.target!.symbol))
              .order(AssetHistoryTimeValue_.date, flags: Order.descending)
              .build()
              .findFirst()
              ?.value ??
          0;

      return (value * getTotalQuantity())
          .atMainCurrency(fromCurrency: marketInfo.target!.currency);
    }
  }

  double getTotalQuantity() {
    double q = 0;
    var timeValues = GetIt.I<Store>().box<Asset>().get(id)!.timeValues;
    for (var element in timeValues) {
      q = Decimal.parse(q.toString()).toDouble() + Decimal.parse(element.quantity.toString()).toDouble();
    }
    return q;
  }

  DateTime? getOldestTimeValueDate() {
    return getTimeValuesChronologicalOrder().firstOrNull?.date;
  }

  /// if @latestFirst is false, the oldest value is the first of the list, otherwise the last
  List<AssetTimeValue> getTimeValuesChronologicalOrder({
    bool latestFirst = false,
  }) {
    var timeValues = GetIt.I<Store>().box<Asset>().get(id)!.timeValues;
    var values = timeValues.toList();
    values.sort((a, b) =>
        latestFirst ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
    return values;
  }

  double getQuantityAtDateTime(DateTime dateTime) {
    var subList = getTimeValuesChronologicalOrder()
        .where((element) =>
            element.date.isBefore(dateTime.add(const Duration(days: 1))))
        .toList();
    double q = 0;
    for (var element in subList) {
      q = q + element.quantity;
    }
    return q;
  }

  double getPerformance({DateTime? startDateTime}) {
    double p = 0.0;
    var timeValues = GetIt.I<Store>().box<Asset>().get(id)!.timeValues;
    if (startDateTime == null || startDateTime == getOldestTimeValueDate()) {
      for (var element in timeValues) {
        p = p + element.getPerformance(marketInfo.target!.symbol);
      }
    } else {
      double valueAtStartDateTime =
          AssetRepoImpl().getValueAtDateTime(this, startDateTime);
      List<AssetTimeValue> positionsAfterStartDateTime = timeValues
          .where((value) => value.date.isAfter(startDateTime))
          .toList();
      double newPositionCost = 0;
      positionsAfterStartDateTime.forEach((position) {
        newPositionCost = newPositionCost + position.getTotalPurchaseValue();
      });

      p = getCurrentValue() - valueAtStartDateTime - newPositionCost;
    }
    return double.parse(p.toStringAsFixed(2));
  }

  double getPerformancePerc({DateTime? startDateTime}) {
    if (startDateTime == null || startDateTime == getOldestTimeValueDate()) {
      var timeValues = GetIt.I<Store>().box<Asset>().get(id)!.timeValues;

      double amountSpent = 0.0;
      for (var element in timeValues) {
        amountSpent = amountSpent + element.getTotalPurchaseValue();
      }

      return double.parse(
          ((getCurrentValue() - amountSpent) / amountSpent * 100)
              .toStringAsFixed(1));
    } else {
      double valueAtStartDateTime =
          AssetRepoImpl().getValueAtDateTime(this, startDateTime);
      double perf = getPerformance(startDateTime: startDateTime) /
          valueAtStartDateTime *
          100;
      return double.parse(perf.toStringAsFixed(1));
    }
  }

  /// get total amount invested until dateTime, if specified, or all
  double getTotalAmountInvested({DateTime? dateTime}) {
    double totPurchasePrice = 0;
    List<AssetTimeValue> positions = dateTime == null
        ? timeValues
        : timeValues
            .where((position) =>
                position.date == dateTime || position.date.isBefore(dateTime))
            .toList();

    for (var item in positions) {
      totPurchasePrice = totPurchasePrice +
          (item.quantity *
              item.value
                  .atMainCurrency(fromCurrency: item.currency.target!.name));
    }
    return double.parse(totPurchasePrice.toStringAsFixed(2));
  }

  double getAvgPurchasePrice() {
    if (getTotalQuantity() == 0) return 0;
    return double.parse(
        (getTotalAmountInvested() / getTotalQuantity()).toStringAsFixed(2));
  }
}
