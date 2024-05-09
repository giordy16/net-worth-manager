import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';

import '../../../utils/form_component_border.dart';
import '../../../utils/form_validators.dart';

class AppSelectorField<T> extends StatelessWidget {
  static AssetCategory addNewCategory = AssetCategory("+ Create new category");

  T? initialValue;
  List<T> values;
  String title;
  Function(T)? onItemSelected;
  bool shouldAddCreateEntityOption;
  bool isMandatory;

  AppSelectorField({
    super.key,
    this.initialValue,
    required this.values,
    required this.title,
    this.shouldAddCreateEntityOption = false,
    this.onItemSelected,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return DropdownButtonFormField2(
        items: values.map<DropdownMenuItem>((entity) {
          return DropdownMenuItem(
            value: entity,
            child: Text(
              entity.toString(),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (onItemSelected != null) {
            onItemSelected!(value);
          }
        },
        decoration: InputDecoration(
          label: Text(title),
          labelStyle: TextStyle(color: theme.colorScheme.secondary),
          errorBorder: formErrorBorder(context),
          focusedBorder: formFocusedBorder(context),
          enabledBorder: formEnabledBorder(context),
          focusedErrorBorder: formFocusedBorder(context),
        ),
        validator: isMandatory ? mandatoryFieldDynamic() : null,
        value: initialValue,
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
        customButton: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                (initialValue ?? "").toString(),
                style: TextStyle(color: Colors.white),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ));
  }
}
