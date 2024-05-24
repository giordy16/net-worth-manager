extension DateTimeExtension on DateTime {
  double getMinutesFromEpoch() {
    return millisecondsSinceEpoch / 1000 / 60;
  }

  DateTime keepOnlyYMD() {
    return DateTime(year, month, day);
  }

}