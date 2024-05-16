import 'package:equatable/equatable.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';

class AddPositionState extends Equatable {
  final AssetTimeValue? value;

  const AddPositionState({this.value});

  AddPositionState copyWith({
    AssetTimeValue? value,
  }) {
    return AddPositionState(
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [value];
}
