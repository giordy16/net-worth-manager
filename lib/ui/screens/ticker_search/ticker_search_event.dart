import '../../../models/obox/market_info_obox.dart';

abstract class TickerSearchEvent {}

class SearchTicker extends TickerSearchEvent {
  String ticker;

  SearchTicker(this.ticker);
}

class SearchStartedEvent extends TickerSearchEvent {}

class SearchCompletedEvent extends TickerSearchEvent {
  List<MarketInfo> list;

  SearchCompletedEvent(this.list);
}
