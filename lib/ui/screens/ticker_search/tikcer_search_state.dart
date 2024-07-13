import 'package:equatable/equatable.dart';

import '../../../models/obox/market_info_obox.dart';

class TickerSearchState extends Equatable {
  String? searchedName;
  String? searchedISIN;
  List<MarketInfo>? assetList;

  String? commoditySearched;
  List<MarketInfo>? commoditiesList;

  bool showProgress;

  TickerSearchState({
    this.searchedName,
    this.searchedISIN,
    this.assetList,
    this.commoditySearched,
    this.commoditiesList,
    required this.showProgress,
  });

  @override
  List<Object?> get props => [
        searchedName,
        searchedISIN,
        assetList,
        commoditySearched,
        commoditiesList,
        showProgress,
      ];

  TickerSearchState copyWith({
    String? searchedName,
    String? searchedISIN,
    List<MarketInfo>? assetList,
    String? commoditySearched,
    List<MarketInfo>? commoditiesList,
    bool? showProgress,
  }) {
    return TickerSearchState(
      showProgress: showProgress ?? this.showProgress,
      searchedName: searchedName ?? this.searchedName,
      searchedISIN: searchedISIN ?? this.searchedISIN,
      assetList: assetList ?? this.assetList,
      commoditySearched: commoditySearched ?? this.commoditySearched,
      commoditiesList: commoditiesList ?? this.commoditiesList,
    );
  }
}
