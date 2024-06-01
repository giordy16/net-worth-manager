import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_screen.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

import '../../../main.dart';
import '../../../models/obox/currency_obox.dart';
import '../../../models/obox/settings_obox.dart';
import '../../../objectbox.g.dart';
import '../../../utils/form_component_border.dart';
import '../../../utils/form_validators.dart';

class AppNumericTextField extends StatefulWidget {
  double? initialValue;
  String title;
  bool isMandatory;
  Currency? currency;
  bool moneyBehavior;
  bool userCanChangeCurrency;
  Function(String)? onTextChange;
  Function(Currency)? onCurrencyChange;

  AppNumericTextField({
    super.key,
    required this.moneyBehavior,
    this.initialValue,
    this.title = "",
    this.onTextChange,
    this.onCurrencyChange,
    this.isMandatory = false,
    this.currency,
    this.userCanChangeCurrency = true,
  });

  @override
  State<StatefulWidget> createState() => _AppNumericTextFieldState();
}

class _AppNumericTextFieldState extends State<AppNumericTextField> {
  late TextEditingController controller;
  late Currency currency;
  final allowedSymbols = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "-",
  ];

  String oldText = "";
  Settings settings = GetIt.instance<Settings>();

  void initController() {
    controller = TextEditingController(
        text: widget.initialValue != null
            ? widget.initialValue!.toStringFormatted(removeGroupSeparator: true)
            : "");
    oldText = controller.text;

    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
  }

  @override
  void initState() {
    super.initState();
    initController();
    initCurrency();

    allowedSymbols.add(
        numberFormatSymbols[Platform.localeName.split("_").first]?.DECIMAL_SEP);
  }

  void initCurrency() {
    if (widget.currency != null) {
      currency = widget.currency!;
    } else {
      currency = settings.defaultCurrency.target!;
    }
  }

  @override
  void didUpdateWidget(AppNumericTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    initController();
    initCurrency();
  }

  bool isTextOk(String text) {
    if (text.isEmpty) return true;

    // the - can be only in first position
    if (text.contains("-") && text.characters.first != "-") return false;

    // only one "," is allowed
    if (text.characters.where((c) => c == ",").length > 1) return false;

    // only allowedSymbols are allowed
    if (!allowedSymbols.contains(text.characters.last)) return false;

    // only 2 digits after "," are allowed
    if (widget.moneyBehavior &&
        text.contains(",") &&
        text.split(",")[1].length > 2) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9.,-]')),
      ],
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        label: Text(widget.title),
        suffixIcon: Visibility(
          visible: widget.moneyBehavior,
          child: IconButton(
            icon: Text(
              currency.symbol,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
            onPressed: widget.userCanChangeCurrency
                ? () async {
                    Currency? c = await context.push(
                        CurrencySelectionScreen.route,
                        extra: currency) as Currency?;
                    if (c == null) return;
                    if (widget.onCurrencyChange != null) {
                      widget.onCurrencyChange!(c);
                    }
                    if (context.mounted) setState(() {});
                  }
                : null,
          ),
        ),
        labelStyle: TextStyle(color: theme.colorScheme.secondary),
        errorBorder: formErrorBorder(context),
        focusedBorder: formFocusedBorder(context),
        enabledBorder: formEnabledBorder(context),
        focusedErrorBorder: formFocusedBorder(context),
      ),
      onChanged: (value) {
        if (isTextOk(value)) {
          oldText = value;
          if (widget.onTextChange != null) widget.onTextChange!(value);
        } else {
          controller.text = oldText;
        }
      },
      validator: widget.isMandatory ? mandatoryField() : null,
    );
  }
}
