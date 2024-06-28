extension DateTimeExtension on DateTime {
  double getMinutesFromEpoch() {
    return millisecondsSinceEpoch / 1000 / 60;
  }

  DateTime keepOnlyYMD() {
    return DateTime(year, month, day);
  }

  DateTime get lastDayOfTheMonth {
    return month < 12 ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);
  }

  DateTime get lastDayOfThePreviousMonth {
    return DateTime(year, month, 0);
  }

  DateTime get lastDayOfTheNextMonth {
    return DateTime(year, month + 2, 0);
  }
}
