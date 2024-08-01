import 'package:flutter/material.dart';
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
  bool expandedMode;
  TextEditingController controller;
  int? maxLines;

  AppTextField({
    super.key,
    this.initialValue = "",
    this.title = "",
    this.onTextChange,
    this.keyboardType,
    this.prefixIcon,
    this.isMandatory = false,
    this.readOnly = false,
    this.expandedMode = false,
    this.maxLines = 1,
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
      textAlignVertical: TextAlignVertical.top,
      expands: expandedMode,
      maxLines: expandedMode ? null : maxLines,
      decoration: InputDecoration(
        label: Text(title),
        alignLabelWithHint: true,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        labelStyle: TextStyle(color: theme.colorScheme.primary),
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
