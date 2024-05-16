import 'package:intl/intl.dart';

import '../../models/obox/asset_obox.dart';
import '../../ui/widgets/graph/simple_asset_line_graph.dart';

enum DataGap { all, ytd, g60, g30 }

extension DataGapExt on DataGap {
  String getName() {
    switch (this) {
      case DataGap.all:
        return "ALL";
      case DataGap.ytd:
        return "YTD";
      case DataGap.g30:
        return "30 D";
      case DataGap.g60:
        return "60 D";
    }
  }

  DateTime getStartDate(Asset asset) {
    switch (this) {
      case DataGap.all:
        return asset.getFirstTimeValueDate()!;
      case DataGap.ytd:
        return DateTime(SimpleAssetLineGraph.today.year);
      case DataGap.g60:
        return SimpleAssetLineGraph.today.subtract(const Duration(days: 60));
      case DataGap.g30:
        return SimpleAssetLineGraph.today.subtract(const Duration(days: 30));
    }
  }

  DateTime getEndDate() {
    return SimpleAssetLineGraph.today;
  }

  DateFormat getDateFormat() {
    switch (this) {
      case DataGap.all:
        return DateFormat("MMM yy");
      case DataGap.ytd:
        return DateFormat("dd MMM");
      case DataGap.g60:
        return DateFormat("dd MMM");
      case DataGap.g30:
        return DateFormat("dd MMM");
    }
  }
}