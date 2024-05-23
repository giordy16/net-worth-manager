import 'package:intl/intl.dart';

import '../../models/obox/asset_obox.dart';
import '../../ui/widgets/graph/simple_asset_line_graph.dart';

enum GraphTime { all, fiveYears, oneYear, ytd, threeMonths, oneMonth }

extension DataGapExt on GraphTime {
  String getName() {
    switch (this) {
      case GraphTime.all:
        return "ALL";
      case GraphTime.fiveYears:
        return "5Y";
      case GraphTime.oneYear:
        return "1Y";
      case GraphTime.ytd:
        return "YTD";
      case GraphTime.threeMonths:
        return "3M";
      case GraphTime.oneMonth:
        return "1M";
    }
  }

  DateTime getStartDate(Asset asset) {
    DateTime assetFirstDate = asset.getFirstTimeValueDate()!;

    switch (this) {
      case GraphTime.all:
        return assetFirstDate;
      case GraphTime.ytd:
        return DateTime(SimpleAssetLineGraph.today.year);
      case GraphTime.threeMonths:
        DateTime subDate =
            SimpleAssetLineGraph.today.subtract(const Duration(days: 60));
        return subDate.isBefore(assetFirstDate) ? assetFirstDate : subDate;
      case GraphTime.oneMonth:
        DateTime subDate =
            SimpleAssetLineGraph.today.subtract(const Duration(days: 30));
        return subDate.isBefore(assetFirstDate) ? assetFirstDate : subDate;
      case GraphTime.fiveYears:
        DateTime subDate =
            SimpleAssetLineGraph.today.subtract(const Duration(days: 365 * 5));
        return subDate.isBefore(assetFirstDate) ? assetFirstDate : subDate;
      case GraphTime.oneYear:
        DateTime subDate =
            SimpleAssetLineGraph.today.subtract(const Duration(days: 365));
        return subDate.isBefore(assetFirstDate) ? assetFirstDate : subDate;
    }
  }

  DateTime getEndDate() {
    return SimpleAssetLineGraph.today;
  }

  DateFormat getDateFormat() {
    switch (this) {
      case GraphTime.all:
      case GraphTime.fiveYears:
      case GraphTime.oneYear:
        return DateFormat("MMM yy");
      case GraphTime.ytd:
      case GraphTime.threeMonths:
      case GraphTime.oneMonth:
        return DateFormat("dd MMM");
    }
  }
}
