import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/ticker_search_event.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/tikcer_search_state.dart';

import '../../../domain/repository/stock/financial_modeling_repo.dart';

class TickerSearchBloc extends Bloc<TickerSearchEvent, TickerSearchState> {
  final FinancialModelingRepoImpl avRepo;

  Timer? _debounce;

  TickerSearchBloc({
    required this.avRepo,
  }) : super(TickerSearchState(showProgress: false)) {
    on<SearchTicker>((event, emit) {
      _debounce?.cancel();
      emit(state.copyWith(searchedTicker: event.ticker));

      if (event.ticker.isEmpty) {
        emit(state.copyWith(assetList: [], showProgress: false));
      } else if (event.ticker.isNotEmpty) {
        _debounce = Timer(const Duration(milliseconds: 1000), () async {
          print(event.ticker);

          add(SearchStartedEvent());
          await avRepo.searchTicker(event.ticker).then((value) {
            add(SearchCompletedEvent(value));
          });
        });
      }
    });

    on<SearchCompletedEvent>((event, emit) {
      emit(state.copyWith(assetList: event.list, showProgress: false));
    });

    on<SearchStartedEvent>((event, emit) {
      emit(state.copyWith(showProgress: true));
    });
  }
}
