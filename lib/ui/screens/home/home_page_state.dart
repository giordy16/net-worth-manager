import 'package:equatable/equatable.dart';

import '../../../models/obox/asset_obox.dart';

class HomePageState extends Equatable {
  final double? netWorthValue;
  final List<Asset>? assets;

  const HomePageState({
    this.netWorthValue,
    this.assets,
  });

  HomePageState copyWith({
    double? netWorthValue,
    List<Asset>? assets,
  }) {
    return HomePageState(
      netWorthValue: netWorthValue ?? this.netWorthValue,
      assets: assets ?? this.assets,
    );
  }

  @override
  List<Object?> get props => [netWorthValue, assets];
}
