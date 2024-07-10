import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_screen.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

import '../../../models/obox/currency_obox.dart';
import '../../../models/obox/settings_obox.dart';
import '../../../utils/form_component_border.dart';
import '../../../utils/form_validators.dart';
import '../../screens/currency_selection/currency_selection_params.dart';

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

  String oldText = "";
  Settings settings = GetIt.instance<Settings>();

  void initController() {
    controller = TextEditingController(
        text: widget.initialValue != null
            ? widget.initialValue!.toStringFormatted(
                removeGroupSeparator: true,
                removeDecimalPartIfZero: true,
              )
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

    // only number are allowed
    if (double.tryParse(text) == null) return false;

    // only 2 digits after "," are allowed if is money textfield
    if (widget.moneyBehavior &&
        text.contains(".") &&
        text.split(".")[1].length > 2) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      keyboardType: widget.moneyBehavior
          ? const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            )
          : const TextInputType.numberWithOptions(decimal: true),
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
                        extra: CurrencySelectionParams(
                            selectedCurrency: currency)) as Currency?;
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
        value = value.replaceAll(",", ".");
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
