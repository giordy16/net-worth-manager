String? Function(String? value) mandatoryField() {
  return (value) {
    if (value == null || value.isEmpty) {
      return 'This field is mandatory';
    }
    return null;
  };
}

String? Function(dynamic value) mandatoryFieldDynamic() {
  return (value) {
    if (value == null) {
      return 'This field is mandatory';
    }
    return null;
  };
}

String? Function(String? value) validNumber() {
  return (value) {
    if (value == null || value.isEmpty) {
      return 'This field is mandatory';
    }
    if (double.tryParse(value) == null) {
      return 'Please insert a valid number';
    }
    return null;
  };
}
