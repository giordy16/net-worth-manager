import 'package:flutter/material.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

enum PerformanceShowType { row, column }

class PerformanceBox extends StatelessWidget {
  String? currentValue;
  double performance;
  double performancePerc;
  PerformanceShowType showType;

  PerformanceBox(
      {this.currentValue,
      required this.performance,
      required this.performancePerc,
      required this.showType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: currentValue != null,
          child: Text(currentValue!),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            Text(
              "${performance >= 0 ? "+" : ""}${performance.toStringWithCurrency()}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: performance >= 0 ? Colors.green : Colors.red),
            ),
            SizedBox(width: 4),
            Container(
              decoration: BoxDecoration(
                  color: (performance >= 0 ? Colors.green : Colors.red)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              padding: EdgeInsets.all(2),
              child: Text(
                "$performancePerc%",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: performance >= 0 ? Colors.green : Colors.red),
              ),
            )
          ],
        )
      ],
    );
  }
}
