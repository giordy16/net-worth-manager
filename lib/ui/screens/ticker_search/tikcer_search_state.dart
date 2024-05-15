import 'package:equatable/equatable.dart';

import '../../../models/obox/market_info_obox.dart';

class TickerSearchState extends Equatable {
  String? searchedTicker;
  List<MarketInfo>? assetList;
  bool showProgress;

  TickerSearchState(
      {this.searchedTicker, this.assetList, required this.showProgress});

  @override
  List<Object?> get props => [assetList, searchedTicker, showProgress];

  TickerSearchState copyWith({
    List<MarketInfo>? assetList,
    bool? showProgress,
    String? searchedTicker,
  }) {
    return TickerSearchState(
      assetList: assetList ?? this.assetList,
      showProgress: showProgress ?? this.showProgress,
      searchedTicker: searchedTicker ?? this.searchedTicker,
    );
  }
}
