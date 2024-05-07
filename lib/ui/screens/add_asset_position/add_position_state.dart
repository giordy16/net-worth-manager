import 'package:equatable/equatable.dart';

class AddPositionState extends Equatable {
  final DateTime? dateTime;
  final double? cost;

  const AddPositionState({
    this.dateTime,
    this.cost,
  });

  AddPositionState copyWith({
    DateTime? dateTime,
    double? cost,
  }) {
    return AddPositionState(
      dateTime: dateTime ?? this.dateTime,
      cost: cost ?? this.cost,
    );
  }

  @override
  List<Object?> get props => [dateTime, cost];
}
