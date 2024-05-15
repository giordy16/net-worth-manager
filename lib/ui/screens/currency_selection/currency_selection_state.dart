import 'package:equatable/equatable.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';

class CurrencySelectionState extends Equatable {
  final String search;
  final List<Currency> currenciesList;

  const CurrencySelectionState({
    this.search = "",
    this.currenciesList = const [],
  });

  CurrencySelectionState copyWith({
    String? search,
    List<Currency>? currenciesList,
  }) {
    return CurrencySelectionState(
      search: search ?? this.search,
      currenciesList: currenciesList ?? this.currenciesList,
    );
  }

  @override
  List<Object?> get props => [currenciesList];
}
