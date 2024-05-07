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