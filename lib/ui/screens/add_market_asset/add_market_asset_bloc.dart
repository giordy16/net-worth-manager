import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_event.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_state.dart';
import 'package:net_worth_manager/ui/widgets/modal/loading_overlay.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';

import '../../../domain/repository/asset/asset_repo.dart';
import '../../../domain/repository/stock/stock_api.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';

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

      LoadingOverlay.of(context).show();

      await GetIt.I<Store>().syncForexPrices(currencyToFetch: marketInfo.currency);
      await stockApi.fetchPriceHistoryBySymbol(marketInfo);

      assetRepo.saveMarketValue(marketInfo);
      assetRepo.saveAsset(asset);

      var assetPositionsDate =
      asset.timeValues.map((element) => element.date).toList();
      if (assetPositionsDate.isNotEmpty) {
        DateTime oldestDate =
        assetPositionsDate.reduce((a, b) => a.isBefore(b) ? a : b);
        await netWorthRepo.updateNetWorth(updateStartingDate: oldestDate);
      }

      LoadingOverlay.of(context).hide();
      context.pop();
    });
  }
}
