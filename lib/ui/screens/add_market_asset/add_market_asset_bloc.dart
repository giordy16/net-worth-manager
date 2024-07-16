import 'package:bloc/bloc.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_event.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_state.dart';
import 'package:net_worth_manager/ui/widgets/modal/bottom_sheet.dart';
import 'package:net_worth_manager/ui/widgets/modal/loading_overlay.dart';
import 'package:net_worth_manager/utils/ad_mob.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';

import '../../../domain/repository/asset/asset_repo.dart';
import '../../../domain/repository/stock/stock_api.dart';
import '../../../i18n/strings.g.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../models/obox/asset_time_value_obox.dart';
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
      loadAd();

      Asset asset = event.asset;
      MarketInfo marketInfo = asset.marketInfo.target!;

      LoadingOverlay.of(context).show();

      var positionsInfluencedBySplit =
          await checkSharesSplit(marketInfo.symbol, event.newPositions);

      if (positionsInfluencedBySplit != null) {
        // there are some position influenced by split
        for (var posInfluenced in positionsInfluencedBySplit.entries) {
          for (var pos in asset.timeValues) {
            if (pos == posInfluenced.key) {
              pos.quantity = posInfluenced.value;
            }
          }
        }
      }

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
    });
  }

  Future<Map<AssetTimeValue, double>?> checkSharesSplit(
      String symbol, List<AssetTimeValue> positions) async {
    if (positions.isEmpty) return null;

    final splitHistory = await stockApi.getSplitHistorical(symbol);
    if (splitHistory.isEmpty) return null;

    Map<AssetTimeValue, double> positionsInfluencedBySplit = {};

    for (var pos in positions) {
      double qtX = 1;
      for (var split in splitHistory) {
        if (pos.date.isBefore(split.dateFormatted)) {
          qtX = (qtX.toDecimal() *
                  split.numerator.toDecimal() /
                  split.denominator.toDecimal())
              .toDouble();
        }
      }
      if (qtX != 1) {
        positionsInfluencedBySplit.addAll({pos: qtX});
      }
    }

    if (positionsInfluencedBySplit.isNotEmpty) {
      var message = positionsInfluencedBySplit.entries
          .map((entry) => t.stock_split_message_single
              .replaceAll(
                  "<date>", DateFormat("dd/MM/yyyy").format(entry.key.date))
              .replaceAll("<qt>", entry.key.quantity.toStringFormatted())
              .replaceAll("<qtSplit>", entry.value.toStringFormatted()))
          .join("\n");

      bool? yes = await showYesNoBottomSheet(context,
          t.stock_split_message_positions.replaceAll("<message>", message),
          isDismissible: false,
          widgetAboveSelection: IconButton(
              onPressed: () {
                showOkOnlyBottomSheet(context, t.what_is_a_share_split_content);
              },
              icon: Text(
                t.what_is_a_share_split,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white),
              )));

      if (yes == true) {
        return positionsInfluencedBySplit;
      }
    }
    return null;
  }

  void loadAd() {
    InterstitialAd.load(
        adUnitId: ADMob.getPopUpAdId(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                  goBack();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});
            ad.show();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            goBack();
          },
        ));
  }


  void goBack() {
    UserMessage.showMessage(context, t.done);
    LoadingOverlay.of(context).hide();
    context.pop();
  }

}
