import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_event.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_state.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';
import 'package:net_worth_manager/utils/forex.dart';

import '../../../domain/repository/asset/asset_repo.dart';
import '../../../domain/repository/stock/stock_api.dart';
import '../../../models/obox/asset_obox.dart';

class AddMarketAssetBloc
    extends Bloc<AddMarketAssetEvent, AddMarketAssetState> {
  final BuildContext context;
  final AssetRepo assetRepo;
  final StockApi stockApi;
  final NetWorthRepo netWorthRepo;

  AddMarketAssetBloc(
    this.context,
    this.assetRepo,
    this.stockApi,
    this.netWorthRepo,
  ) : super(AddMarketAssetState()) {
    on<SaveMarketAssetEvent>((event, emit) async {
      Asset asset = event.asset;
      MarketInfo marketInfo = asset.marketInfo.target!;

      // todo show progress

      await objectbox.syncForexPrices(currencyToFetch: marketInfo.currency);
      await stockApi.fetchPriceHistoryBySymbol(marketInfo);

      assetRepo.saveMarketValue(marketInfo);
      assetRepo.saveAsset(asset);

      var assetPositionsDate =
      asset.timeValues.map((element) => element.date).toList();
      if (assetPositionsDate.isNotEmpty) {
        DateTime oldestDate =
        assetPositionsDate.reduce((a, b) => a.isBefore(b) ? a : b);
        netWorthRepo.updateNetWorth(updateStartingDate: oldestDate);
      }

      context.pop();
    });
  }
}
