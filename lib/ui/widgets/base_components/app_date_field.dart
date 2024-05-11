import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/form_component_border.dart';
import '../../../utils/form_validators.dart';

class AppDateField extends StatefulWidget {
  DateTime? initialValue;
  String title;
  Function(DateTime)? onDatePicked;
  bool isMandatory;

  AppDateField({
    super.key,
    this.initialValue,
    this.title = "",
    this.onDatePicked,
    this.isMandatory = false,
  });

  @override
  State<StatefulWidget> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    initController();
  }

  @override
  void didUpdateWidget(AppDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    initController();
  }

  void initController() {
    controller = TextEditingController(
        text: widget.initialValue != null
            ? dateFormat.format(widget.initialValue!)
            : null);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      textCapitalization: TextCapitalization.sentences,
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: null,
            firstDate: DateTime(1990),
            lastDate: DateTime.now());
        if (picked != null) {
          setState(() {
            controller.text = dateFormat.format(picked);
          });

          if (widget.onDatePicked != null) {
            widget.onDatePicked!(picked);
          }
        }
      },
      decoration: InputDecoration(
        label: Text(widget.title),
        labelStyle: TextStyle(color: theme.colorScheme.secondary),
        errorBorder: formErrorBorder(context),
        focusedBorder: formFocusedBorder(context),
        enabledBorder: formEnabledBorder(context),
        focusedErrorBorder: formFocusedBorder(context),
      ),
      validator: widget.isMandatory ? mandatoryField() : null,
    );
  }
}
