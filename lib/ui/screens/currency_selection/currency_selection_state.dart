import 'package:equatable/equatable.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';

class CurrencySelectionState extends Equatable {
  final List<Currency> currenciesList;

  const CurrencySelectionState({
    this.currenciesList = const [],
  });

  CurrencySelectionState copyWith({
    List<Currency>? currenciesList,
  }) {
    return CurrencySelectionState(
        currenciesList: currenciesList ?? this.currenciesList);
  }

  @override
  List<Object?> get props => [currenciesList];
}
