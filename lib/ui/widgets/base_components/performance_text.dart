import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

enum PerformanceTextType { value, percentage }

class PerformanceText extends StatelessWidget {
  double performance;
  TextStyle? textStyle;
  PerformanceTextType type;

  PerformanceText({
    required this.performance,
    required this.textStyle,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return type == PerformanceTextType.value
        ? Text(
            "${performance >= 0 ? "+" : ""}${performance.toStringWithCurrency()}",
            style: textStyle?.copyWith(
              color: performance >= 0 ? Colors.green : Colors.red,
            ),
          )
        : Container(
            decoration: BoxDecoration(
                color: (performance >= 0 ? Colors.green : Colors.red)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            padding: EdgeInsets.all(2),
            child: Text(
              "$performance%",
              style: textStyle?.copyWith(
                color: performance >= 0 ? Colors.green : Colors.red,
              ),
            ),
          );
  }
}
