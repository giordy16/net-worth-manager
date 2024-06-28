abstract class NetWorthRepo {

  Future<void> updateNetWorth({DateTime? updateStartingDate});

  double getNetWorth();

  Future<Map<DateTime, double>> getNetWorthsAtTheEndOfMonths();

}