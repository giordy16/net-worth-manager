import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/ticker_search_bloc.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/tikcer_search_state.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_text_field.dart';
import 'package:net_worth_manager/utils/extensions/mappers.dart';

import '../../../domain/repository/stock/financial_modeling_repo.dart';
import '../../../i18n/strings.g.dart';
import '../../../models/obox/market_info_obox.dart';
import '../../widgets/app_divider.dart';
import '../add_market_asset/add_market_asset_screen.dart';
import '../add_market_asset/add_market_asset_screen_params.dart';
import 'components/ticker_list_item.dart';

class TickerSearchScreen extends StatelessWidget {
  static const route = "/TickerSearchScreen";

  TickerSearchScreen({super.key});

  void onItemClick(BuildContext context, MarketInfo info) {
    // if (info.exchangeNameShort != "NASDAQ" &&
    //     info.exchangeNameShort != "CRYPTO") {
    //   showOkOnlyBottomSheet(context,
    //       "At the moment only Crypto and assets exchanged on NASDAQ are selectable.");
    // } else {
    context.push(AddMarketAssetScreen.route,
        extra: AddMarketAssetScreenParams(asset: info.convertToAsset()));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => FinancialModelingRepoImpl(context: context),
        child: BlocProvider(
            create: (context) => TickerSearchCubit(
                  avRepo: context.read<FinancialModelingRepoImpl>(),
                ),
            child: BlocBuilder<TickerSearchCubit, TickerSearchState>(
                builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(t.search),
                  ),
                  body: SafeArea(
                      child: Padding(
                          padding:
                              const EdgeInsets.all(Dimensions.screenMargin),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.ticker_search_subtitle),
                                SizedBox(height: 16),
                                AppTextField(
                                  title: t.ticker_or_name,
                                  initialValue: state.searchedName,
                                  onTextChange: (name) {
                                    context
                                        .read<TickerSearchCubit>()
                                        .searchAssetByName(name);
                                  },
                                ),
                                SizedBox(height: 16),
                                AppTextField(
                                  title: "ISIN",
                                  initialValue: state.searchedISIN,
                                  onTextChange: (isin) {
                                    context
                                        .read<TickerSearchCubit>()
                                        .searchAssetByISIN(isin);
                                  },
                                ),
                                const SizedBox(height: Dimensions.l),
                                getBody(context, state),
                              ]))));
            })));
  }

  Widget getBody(BuildContext context, TickerSearchState state) {
    if (state.showProgress) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (state.assetList?.isNotEmpty == true) {
      return Expanded(
        child: ListView.separated(
            itemBuilder: (context, index) {
              return TickerListItem(state.assetList![index],
                  (info) => onItemClick(context, info));
            },
            separatorBuilder: (context, index) {
              return AppDivider(height: 16);
            },
            itemCount: state.assetList!.length),
      );
    }

    if ((state.searchedName?.isNotEmpty == true ||
            state.searchedISIN?.isNotEmpty == true) &&
        state.assetList?.isEmpty == true) {
      return Expanded(child: Center(child: Text(t.no_result_found)));
    }

    return Container();
  }
}
