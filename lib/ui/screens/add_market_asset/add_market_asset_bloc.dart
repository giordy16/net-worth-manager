import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_event.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_state.dart';

import '../../../domain/repository/asset/asset_repo.dart';
import '../../../domain/repository/stock/StockApi.dart';
import '../../../models/obox/asset_obox.dart';

class AddMarketAssetBloc
    extends Bloc<AddMarketAssetEvent, AddMarketAssetState> {
  final BuildContext context;
  final AssetRepo assetRepo;
  final StockApi stockApi;

  AddMarketAssetBloc(
    this.context,
    this.assetRepo,
    this.stockApi,
  ) : super(AddMarketAssetState()) {
    on<SaveMarketAssetEvent>((event, emit) async {
      Asset asset = event.asset;
      MarketInfo marketInfo = asset.marketInfo.target!;

      double price =
          await stockApi.getLastPriceBySymbol(marketInfo.symbol) ?? 0;

      marketInfo.value = price;
      assetRepo.saveMarketValue(marketInfo);
      assetRepo.saveAsset(asset);
    });
  }
}
