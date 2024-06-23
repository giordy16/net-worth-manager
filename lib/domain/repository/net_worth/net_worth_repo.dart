abstract class NetWorthRepo {

  Future<void> updateNetWorth({DateTime? updateStartingDate});

  double getNetWorth();

  Map<DateTime, double> getNetWorthsAtTheEndOfMonths();

}