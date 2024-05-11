import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:net_worth_manager/app_dimensions.dart';

import '../../../utils/form_component_border.dart';
import '../../../utils/form_validators.dart';

class AppTextField extends StatelessWidget {
  String? initialValue;
  String title;
  Function(String)? onTextChange;
  TextInputType? keyboardType;
  IconData? prefixIcon;
  bool isMandatory;
  bool readOnly;
  TextEditingController controller;

  AppTextField({
    super.key,
    this.initialValue = "",
    this.title = "",
    this.onTextChange,
    this.keyboardType,
    this.prefixIcon,
    this.isMandatory = false,
    this.readOnly = false,
  }) : controller = TextEditingController(text: initialValue);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));

    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        label: Text(title),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        labelStyle: TextStyle(color: theme.colorScheme.secondary),
        errorBorder: formErrorBorder(context),
        focusedBorder: formFocusedBorder(context),
        enabledBorder: formEnabledBorder(context),
        focusedErrorBorder: formFocusedBorder(context),
      ),
      onChanged: (value) {
        if (onTextChange != null) onTextChange!(value);
      },
      validator: isMandatory ? mandatoryField() : null,
    );
  }
}
