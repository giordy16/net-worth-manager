extension DateTimeExtension on DateTime {
  double getMinutesFromEpoch() {
    return millisecondsSinceEpoch / 1000 / 60;
  }
}