import 'package:flutter/material.dart';

import '../../utils/TextStyles.dart';

AppBar TopHeader(String title) {
  return AppBar(
    backgroundColor: Colors.white24,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    title: Text(title, style: subTitleTS()),
  );
}
