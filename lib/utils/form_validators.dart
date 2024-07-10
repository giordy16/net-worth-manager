import '../i18n/strings.g.dart';

String? Function(String? value) mandatoryField() {
  return (value) {
    if (value == null || value.isEmpty) {
      return t.filed_mandatory;
    }
    return null;
  };
}

String? Function(dynamic value) mandatoryFieldDynamic() {
  return (value) {
    if (value == null) {
      return t.filed_mandatory;
    }
    return null;
  };
}

String? Function(String? value) validNumber() {
  return (value) {
    if (value == null || value.isEmpty) {
      return t.filed_mandatory;
    }
    if (double.tryParse(value) == null) {
      return t.filed_number_is_invalid;
    }
    return null;
  };
}
