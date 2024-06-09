import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app_dimensions.dart';

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

  void hide() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
                  _text ?? "Just a moment...",
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
