import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/domain/repository/settings/settings_repo_impl.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_bloc.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_event.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_state.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_text_field.dart';

class CurrencySelectionScreen extends StatelessWidget {
  static const route = "/CurrencySelectionScreen";

  const CurrencySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final settingsRepo = SettingsRepoImpl();
    Currency? selectedCurrency = settingsRepo.getDefaultCurrency();

    return RepositoryProvider.value(
      value: settingsRepo,
      child: BlocProvider(
        create: (_) =>
            CurrencySelectionBloc(settingsRepo)..add(FetchCurrencies()),
        child: BlocBuilder<CurrencySelectionBloc, CurrencySelectionState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(title: Text("Select currency")),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.screenMargin),
                    child: AppTextField(
                      title: "Search",
                      initialValue: state.search,
                      prefixIcon: Icons.search,
                      onTextChange: (value) {
                        context
                            .read<CurrencySelectionBloc>()
                            .add(FetchCurrencies(searchText: value));
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Material(
                            child: InkWell(
                              onTap: () {
                                context.pop(state.currenciesList[index]);
                              },
                              child: ListTile(
                                  trailing: (selectedCurrency != null &&
                                          selectedCurrency.id ==
                                              state.currenciesList[index].id)
                                      ? const Icon(Icons.check)
                                      : null,
                                  title: Text(
                                      state.currenciesList[index].toString())),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                              color:
                                  theme.colorScheme.secondary.withOpacity(0.3));
                        },
                        itemCount: state.currenciesList.length),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
