import 'package:flutter/material.dart';

import '../../utils/TextStyles.dart';

AppBar TopHeader(String title, {List<Widget>? actions}) {
  return AppBar(
    backgroundColor: Colors.white24,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    actions: actions,
    title: Container(
      margin: actions != null ? null : EdgeInsets.only(right: 48),
        child: Text(title, style: subTitleTS())),
  );
}
