import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app_dimensions.dart';
import '../../../i18n/strings.g.dart';

class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({super.key, required this.child});

  final Widget child;

  static LoadingOverlayState of(BuildContext context) {
    return context.findAncestorStateOfType<LoadingOverlayState>()!;
  }

  @override
  State<LoadingOverlay> createState() => LoadingOverlayState();
}

class LoadingOverlayState extends State<LoadingOverlay> {
  bool _isLoading = false;
  String? _text;

  Future<void> show({String? text}) async {
    setState(() {
      _text = text;
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> hide() async {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        widget.child,
        if (_isLoading)
          Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: colorScheme.surface),
          ),
        if (_isLoading)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: colorScheme.onSurface),
                const SizedBox(height: Dimensions.m),
                Text(
                  _text ?? t.just_a_moment,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium!.copyWith(color: colorScheme.onSurface),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
