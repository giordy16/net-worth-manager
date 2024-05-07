import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_screen.dart';

import '../../../main.dart';
import '../../../models/obox/settings_obox.dart';
import '../../../utils/form_component_border.dart';
import '../../../utils/form_validators.dart';

class AppMoneyField extends StatefulWidget {
  String initialValue;
  String title;
  Function(String)? onTextChange;
  bool isMandatory;

  AppMoneyField({
    super.key,
    this.initialValue = "",
    this.title = "",
    this.onTextChange,
    this.isMandatory = false,
  });

  @override
  State<StatefulWidget> createState() => _AppMoneyFieldState();
}

class _AppMoneyFieldState extends State<AppMoneyField> {
  late final TextEditingController controller;
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
    ","
  ];

  String oldText = "";

  @override
  void initState() {
    controller = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  bool isTextOk(String text) {
    if (text.contains("-") && text.characters.first != "-") return false;
    if (text.characters.where((c) => c == ",").length > 1) return false;
    if (!allowedSymbols.contains(text.characters.last)) return false;
    if (text.contains(",") && text.split(",")[1].length > 2) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Settings settings = objectbox.store.box<Settings>().getAll().first;
    return TextFormField(
      controller: controller,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        label: Text(widget.title),
        suffixIcon: IconButton(
          icon: Text(
            settings.defaultCurrency.target!.symbol,
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.primary),
          ),
          onPressed: () async {
            await context.push(CurrencySelectionScreen.route);
            setState(() {});
          },
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
