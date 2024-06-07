import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/domain/repository/alphaVantage/alpha_vantage_repo.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo_impl.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_bloc.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_event.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_state.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_text_field.dart';
import 'package:net_worth_manager/ui/widgets/modal/bottom_sheet.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import '../../../domain/repository/asset/asset_repo_impl.dart';
import '../../../models/obox/asset_time_value_obox.dart';
import '../../widgets/base_components/app_bottom_fab.dart';
import '../add_asset_position/add_asset_position_screen.dart';
import '../add_asset_position/add_asset_position_screen_params.dart';
import 'add_market_asset_screen_params.dart';

class AddMarketAssetScreen extends StatefulWidget {
  static const route = "/AddMarketAssetScreen";

  AddMarketAssetScreenParams params;

  AddMarketAssetScreen(this.params, {super.key});

  @override
  State<StatefulWidget> createState() => _AddMarketAssetScreenState();
}

class _AddMarketAssetScreenState extends State<AddMarketAssetScreen> {
  late int lastIndexToHide;

  @override
  void initState() {
    lastIndexToHide = widget.params.asset.timeValues.length - 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AssetRepoImpl>(create: (context) => AssetRepoImpl()),
        RepositoryProvider<NetWorthRepoImpl>(
            create: (context) => NetWorthRepoImpl()),
        RepositoryProvider<AlphaVantageRepImp>(
            create: (context) => AlphaVantageRepImp()),
      ],
      child: BlocProvider(
          create: (context) => AddMarketAssetBloc(
                context,
                context.read<AssetRepoImpl>(),
                context.read<AlphaVantageRepImp>(),
                context.read<NetWorthRepoImpl>(),
              ),
          child: BlocBuilder<AddMarketAssetBloc, AddMarketAssetState>(
              builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Market asset"),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: AppBottomFab(
                text: "Save",
                onTap: () async {
                  context
                      .read<AddMarketAssetBloc>()
                      .add(SaveMarketAssetEvent(widget.params.asset));
                },
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.screenMargin),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppTextField(
                          title: "Asset",
                          initialValue: widget.params.asset.name,
                          readOnly: true,
                        ),
                        const SizedBox(height: Dimensions.l),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index <= lastIndexToHide) {
                              return const SizedBox();
                            }
                            var position =
                                widget.params.asset.timeValues[index];
                            return Material(
                              child: InkWell(
                                onTap: () async {
                                  AssetTimeValue? newPosition = await context
                                      .push(AddAssetPositionScreen.route,
                                          extra: AddAssetPositionScreenParams(
                                            asset: widget.params.asset,
                                            timeValue: widget
                                                .params.asset.timeValues[index],
                                            justPopBack: true,
                                          ));
                                  if (newPosition != null) {
                                    widget.params.asset.timeValues[index] =
                                        newPosition;
                                    setState(() {});
                                  }
                                },
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat("dd/MM/yy")
                                              .format(position.date),
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            "${position.getTotalPurchaseValue().toStringWithCurrency()} | QT. ${position.quantity.toStringFormatted()}"),
                                      ],
                                    ),
                                    const Expanded(child: SizedBox()),
                                    IconButton(
                                        onPressed: () async {
                                          var yes =
                                              await showDeleteConfirmSheet(
                                                  context);
                                          if (yes == true) {
                                            widget.params.asset.timeValues
                                                .removeAt(index);
                                            setState(() {});
                                          }
                                        },
                                        icon: const Icon(Icons.delete_outlined))
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            if (index <= lastIndexToHide) {
                              return const SizedBox();
                            }
                            return const Divider();
                          },
                          itemCount: widget.params.asset.timeValues.length,
                        ),
                        const SizedBox(height: Dimensions.m),
                        const Text("Add position"),
                        const SizedBox(height: Dimensions.xxs),
                        IconButton(
                          onPressed: () async {
                            AssetTimeValue? position =
                                await context.push(AddAssetPositionScreen.route,
                                    extra: AddAssetPositionScreenParams(
                                      asset: widget.params.asset,
                                      justPopBack: true,
                                    ));
                            if (position != null) {
                              widget.params.asset.timeValues.add(position);
                              setState(() {});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              fixedSize: Size(24, 24),
                              backgroundColor: theme.colorScheme.secondary),
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          })),
    );
  }
}
