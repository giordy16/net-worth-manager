import 'package:flutter/material.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

enum PerformanceTextType { value, percentage }

class PerformanceText extends StatelessWidget {
  double performance;
  PerformanceTextType type;
  TextStyle? textStyle;
  TextAlign? textAlign;

  PerformanceText({
    required this.performance,
    required this.type,
    this.textStyle,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return type == PerformanceTextType.value
        ? Text(
            "${performance >= 0 ? "+" : ""}${performance.toStringWithCurrency()}",
            style: textStyle?.copyWith(
              color: performance >= 0 ? Colors.green : Colors.red,
            ),
            textAlign: textAlign,
          )
        : Container(
            decoration: BoxDecoration(
                color: (performance >= 0 ? Colors.green : Colors.red)
                    .withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            padding: const EdgeInsets.all(2),
            child: Text(
              performance == double.infinity ? "STONKS" : "$performance%",
              style: textStyle?.copyWith(
                color: performance >= 0 ? Colors.green : Colors.red,
              ),
            ),
          );
  }
}
