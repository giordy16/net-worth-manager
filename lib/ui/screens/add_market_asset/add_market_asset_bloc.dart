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
import '../../../i18n/strings.g.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';
import '../../../utils/enum/fetch_forex_type.dart';
import '../../widgets/modal/user_message.dart';

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

      assetRepo.saveMarketValue(marketInfo);
      assetRepo.saveAsset(asset);

      var assetPositionsDate =
          asset.timeValues.map((element) => element.date).toList();
      if (assetPositionsDate.isNotEmpty) {
        DateTime oldestDate =
            assetPositionsDate.reduce((a, b) => a.isBefore(b) ? a : b);

        await GetIt.I<Store>().syncForexPrices(
          fetchType: FMPFetchType.addPosition,
          currencyToFetch: marketInfo.currency,
          startFetchDate: oldestDate,
        );

        await stockApi.fetchPriceHistoryBySymbol(
          marketInfo,
          fetchType: FMPFetchType.addPosition,
          startFetchDate: oldestDate,
        );
        await netWorthRepo.updateNetWorth(updateStartingDate: oldestDate);
      } else {
        // fetch either way the price of the assets
        await GetIt.I<Store>().syncForexPrices(
          fetchType: FMPFetchType.addPosition,
          currencyToFetch: marketInfo.currency,
          startFetchDate:
              DateTime.now().copyWith(year: DateTime.now().year - 5),
        );

        await stockApi.fetchPriceHistoryBySymbol(
          marketInfo,
          fetchType: FMPFetchType.addPosition,
          startFetchDate:
              DateTime.now().copyWith(year: DateTime.now().year - 5),
        );
      }

      UserMessage.showMessage(context, t.done);
      LoadingOverlay.of(context).hide();
      context.pop();
    });
  }
}
