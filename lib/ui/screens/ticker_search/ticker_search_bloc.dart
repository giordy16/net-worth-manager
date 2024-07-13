import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/tikcer_search_state.dart';

import '../../../domain/repository/stock/financial_modeling_repo.dart';

class TickerSearchCubit extends Cubit<TickerSearchState> {
  final FinancialModelingRepoImpl avRepo;

  Timer? _debounce;

  TickerSearchCubit({
    required this.avRepo,
  }) : super(TickerSearchState(showProgress: false));

  void searchAssetByName(String name) {
    _debounce?.cancel();
    emit(state.copyWith(searchedName: name, searchedISIN: ""));

    if (name.isEmpty) {
      emit(state.copyWith(assetList: [], showProgress: false));
    } else if (name.isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 1000), () async {
        emit(state.copyWith(showProgress: true));
        final result = await avRepo.searchAssetByNameTicker(name);
        emit(state.copyWith(assetList: result, showProgress: false));
      });
    }
  }

  void searchAssetByISIN(String isin) {
    _debounce?.cancel();
    emit(state.copyWith(searchedName: "", searchedISIN: isin));

    if (isin.isEmpty) {
      emit(state.copyWith(assetList: [], showProgress: false));
    } else if (isin.isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 1000), () async {
        emit(state.copyWith(showProgress: true));
        final result = await avRepo.searchAssetByIsin(isin);
        emit(state.copyWith(assetList: result, showProgress: false));
      });
    }
  }
}
