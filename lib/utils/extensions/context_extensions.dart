import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextExtensions on BuildContext {
  String currentPath() {
    return "${GoRouter.of(this).routeInformationProvider.value.uri.path}/";
  }
}