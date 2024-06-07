import 'package:equatable/equatable.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';

class AddPositionState extends Equatable {
  final AssetTimeValue? value;
  bool showProgress;

  AddPositionState({
    this.value,
    this.showProgress = false,
  });

  AddPositionState copyWith({
    AssetTimeValue? value,
    bool? showProgress,
  }) {
    return AddPositionState(
      value: value ?? this.value,
      showProgress: showProgress ?? this.showProgress,
    );
  }

  @override
  List<Object?> get props => [value, showProgress];
}
