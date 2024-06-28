import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo_impl.dart';
import 'package:net_worth_manager/models/obox/net_worth_history.dart';
import 'package:net_worth_manager/utils/background_thread.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';

import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';
import 'net_worth_repo.dart';

class NetWorthRepoImpl extends NetWorthRepo {
  final assetRepo = AssetRepoImpl();

  @override
  double getNetWorth() {
    return GetIt.I<Store>()
            .box<NetWorthHistory>()
            .query()
            .order(NetWorthHistory_.date, flags: Order.descending)
            .build()
            .findFirst()
            ?.value ??
        0;
  }

  /// When @updateStartingDate is specified, the nw values are updated starting
  /// from @updateStartingDate, so the values before are not updated
  @override
  Future<void> updateNetWorth({DateTime? updateStartingDate}) async {
    var assets = GetIt.I<Store>().box<Asset>().getAll();

    // contains the date of the first AssetTimeValue for each asset
    List<DateTime> oldestAssetsFirstBuys = assets
        .map((asset) =>
            asset.getTimeValuesChronologicalOrder().firstOrNull?.date)
        .nonNulls
        .toList();

    // empty asset
    if (oldestAssetsFirstBuys.isEmpty) {
      GetIt.I<Store>().box<NetWorthHistory>().removeAll();
      return;
    }

    // oldest AssetTimeValue, from where the nw starts
    DateTime oldestAssetDate =
        oldestAssetsFirstBuys.reduce((a, b) => a.isBefore(b) ? a : b);

    // if updateStartingDate != null, use this as starting point
    if (updateStartingDate != null) {
      oldestAssetDate = updateStartingDate;
    }

    final nwBox = GetIt.I<Store>().box<NetWorthHistory>();
    List<NetWorthHistory> nwValues = nwBox
        .query(NetWorthHistory_.date.greaterOrEqualDate(oldestAssetDate))
        .order(NetWorthHistory_.date)
        .build()
        .find();

    // the current oldest nw value has a date grater than [oldestAssetDate], probably
    // because we have just insert a new asset or position with a date < than current oldest nw.
    // For this reason we have to add NetWorthHistory starting from [oldestAssetDate] until reaching nwValues.first
    if (nwValues.isEmpty ||
        (nwValues.firstOrNull != null &&
            nwValues.first.date.isAfter(oldestAssetDate))) {
      int daysToBuffer = 0;

      if (nwValues.isEmpty) {
        daysToBuffer =
            DateTime.now().keepOnlyYMD().difference(oldestAssetDate).inDays;
      } else {
        // we already have the value for nwValues.first, so we need to buffer
        // until nwValues.first.date - 1
        daysToBuffer = nwValues.first.date
            .subtract(Duration(days: 1))
            .difference(oldestAssetDate)
            .inDays;
      }

      List<NetWorthHistory> temp = [];

      for (int i = 0; i <= daysToBuffer; i++) {
        DateTime dateTime =
            oldestAssetDate.add(Duration(days: i)).keepOnlyYMD();
        temp.add(NetWorthHistory(dateTime, 0));
      }
      nwValues = temp + nwValues;
    }

    await runInDifferentThread(() {
      final _nwBox = GetIt.I<Store>().box<NetWorthHistory>();

      for (var element in nwValues) {
        double dayValue = 0;
        for (var asset in assets) {
          // print("asset ${asset.name} at ${element.date} has value ${assetRepo.getValueAtDateTime(asset, element.date)}");
          dayValue =
              dayValue + assetRepo.getValueAtDateTime(asset, element.date);
        }
        element.value = double.parse(dayValue.toStringAsFixed(2));
        _nwBox.put(element);
      }
    });

    // remove nwValues where date < oldestAssetsFirstBuy
    oldestAssetDate =
        oldestAssetsFirstBuys.reduce((a, b) => a.isBefore(b) ? a : b);
    var valuesToDelete = nwBox
        .getAll()
        .where((element) => element.date.isBefore(oldestAssetDate));
    nwBox.removeMany(valuesToDelete.map((e) => e.id!).toList());
  }

  @override
  Future<Map<DateTime, double>> getNetWorthsAtTheEndOfMonths() async {
    return await runInDifferentThread(() {

      Map<DateTime, double> nw = {};

      final nwBox = GetIt.I<Store>().box<NetWorthHistory>();

      DateTime? firstNWDate =
          nwBox.query().order(NetWorthHistory_.date).build().findFirst()?.date;

      if (firstNWDate == null) {
        return nw;
      }

      DateTime lastDayOfTheMonth = firstNWDate.lastDayOfTheMonth;

      while (lastDayOfTheMonth.isBefore(DateTime.now())) {
        double nwValue = nwBox
            .query(NetWorthHistory_.date.lessOrEqualDate(lastDayOfTheMonth))
            .order(NetWorthHistory_.date, flags: Order.descending)
            .build()
            .findFirst()
            ?.value ??
            0;

        nw.addAll({lastDayOfTheMonth: nwValue});

        lastDayOfTheMonth = (lastDayOfTheMonth.copyWith(day: lastDayOfTheMonth.day + 1)).keepOnlyYMD().lastDayOfTheMonth;
      }

      return nw;
    });
  }
}
