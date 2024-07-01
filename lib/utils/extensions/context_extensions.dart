import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../ui/scaffold_with_bottom_navigation.dart';

extension ContextExtensions on BuildContext {
  void clearStackAndReplace(String path) {
    while (appRoutes.canPop() == true) {
      appRoutes.pop();
    }
    appRoutes.pushReplacement(path);
  }

}