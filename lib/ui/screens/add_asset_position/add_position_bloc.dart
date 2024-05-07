import 'package:bloc/bloc.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_event.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_state.dart';

import '../../../domain/repository/asset/asset_repo.dart';

class AddPositionBloc extends Bloc<AddPositionEvent, AddPositionState> {
  final AssetRepo assetRepo;

  AddPositionBloc({
    required this.assetRepo,
  }) : super(const AddPositionState()) {
    on<ChangeDateEvent>((event, emit) {
      emit(state.copyWith(dateTime: event.dateTime));
    });

    on<ChangeCostEvent>((event, emit) {
      emit(state.copyWith(cost: event.cost));
    });

    on<SavePositionEvent>((event, emit) {
      assetRepo.saveNewAssetPosition(
        AssetTimeValue(
          state.dateTime!,
          state.cost!,
        ),
        event.asset,
      );
    });
  }
}
