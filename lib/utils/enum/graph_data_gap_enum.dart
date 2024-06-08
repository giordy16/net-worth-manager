import 'package:intl/intl.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';

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

  DateTime getStartDate(DateTime? oldestDate) {
    DateTime today = DateTime.now().keepOnlyYMD();

    if (oldestDate == null) return today;

    switch (this) {
      case GraphTime.all:
        return oldestDate;
      case GraphTime.ytd:
        return DateTime(today.year);
      case GraphTime.threeMonths:
        DateTime subDate = today.subtract(const Duration(days: 60));
        return subDate.isBefore(oldestDate) ? oldestDate : subDate;
      case GraphTime.oneMonth:
        DateTime subDate = today.subtract(const Duration(days: 30));
        return subDate.isBefore(oldestDate) ? oldestDate : subDate;
      case GraphTime.fiveYears:
        DateTime subDate = today.subtract(const Duration(days: 365 * 5));
        return subDate.isBefore(oldestDate) ? oldestDate : subDate;
      case GraphTime.oneYear:
        DateTime subDate = today.subtract(const Duration(days: 365));
        return subDate.isBefore(oldestDate) ? oldestDate : subDate;
    }
  }

  DateTime getEndDate() {
    return DateTime.now().add(Duration(days: 1)).keepOnlyYMD();
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
