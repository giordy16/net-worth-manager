import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/objectbox.g.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_event.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_state.dart';

import '../../../domain/repository/settings/settings_repo.dart';

class CurrencySelectionBloc
    extends Bloc<CurrencySelectionEvent, CurrencySelectionState> {

  SettingsRepo settingsRepo;

  CurrencySelectionBloc(this.settingsRepo) : super(const CurrencySelectionState()) {

    on<FetchCurrencies>((event, emit) {
      List<Currency> list = [];
      if (event.searchText.isEmpty) {
        list = objectbox.store.box<Currency>().getAll();
      } else {
        list = objectbox.store
            .box<Currency>()
            .query(Currency_.name.contains(event.searchText, caseSensitive: false))
            .build()
            .find();
      }
      emit(state.copyWith(currenciesList: list, search: event.searchText));
    });
  }
}
