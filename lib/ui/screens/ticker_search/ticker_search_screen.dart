import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/ticker_search_bloc.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/ticker_search_event.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/tikcer_search_state.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_text_field.dart';
import 'package:net_worth_manager/utils/extensions/mappers.dart';

import '../../../domain/repository/alphaVantage/alpha_vantage_repo.dart';
import '../../widgets/app_divider.dart';
import '../add_market_asset/add_market_asset_screen.dart';
import '../add_market_asset/add_market_asset_screen_params.dart';
import 'components/ticker_list_item.dart';

class TickerSearchScreen extends StatelessWidget {
  static const route = "/TickerSearchScreen";

  TickerSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return RepositoryProvider(
        create: (_) => AlphaVantageRepImp(),
        child: BlocProvider(
            create: (context) => TickerSearchBloc(
                  avRepo: context.read<AlphaVantageRepImp>(),
                ),
            child: BlocBuilder<TickerSearchBloc, TickerSearchState>(
                builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text("Asset"),
                  ),
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.screenMargin),
                      child: Column(
                        children: [
                          AppTextField(
                            title: "Ticker",
                            initialValue: state.searchedTicker,
                            onTextChange: (ticker) {
                              context
                                  .read<TickerSearchBloc>()
                                  .add(SearchTicker(ticker));
                            },
                          ),
                          const SizedBox(height: Dimensions.l),
                          if (state.showProgress)
                            const Expanded(
                                child:
                                    Center(child: CircularProgressIndicator())),
                          if (!state.showProgress && state.assetList != null)
                            Expanded(
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return TickerListItem(
                                        state.assetList![index], (info) {
                                      context.push(AddMarketAssetScreen.route,
                                          extra: AddMarketAssetScreenParams(
                                              asset: info.convertToAsset()));
                                    });
                                  },
                                  separatorBuilder: (context, index) {
                                    return AppDivider(height: 16);
                                  },
                                  itemCount: state.assetList!.length),
                            )
                        ],
                      ),
                    ),
                  ));
            })));
  }
}
