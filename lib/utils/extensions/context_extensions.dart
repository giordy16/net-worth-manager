import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app_routes.dart';

extension ContextExtensions on BuildContext {
  void clearStackAndReplace(String path) {
    while (appRoutes.canPop() == true) {
      appRoutes.pop();
    }
    appRoutes.pushReplacement(path);
  }

  void popUntilPath(String routePath) {
    while (appRoutes
            .routerDelegate.currentConfiguration.matches.last.matchedLocation !=
        routePath) {
      if (!canPop()) return;

      pop();
    }
  }
}
