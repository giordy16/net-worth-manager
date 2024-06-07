import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../models/obox/currency_obox.dart';
import '../../../models/obox/settings_obox.dart';

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
    Currency mainCurrency = GetIt.I<Settings>().defaultCurrency.target!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: currentValue != null,
          child: Text(
            "$currentValue ${mainCurrency.symbol}",
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            Text(
              "${performance >= 0 ? "+" : ""}$performance ${mainCurrency.symbol}",
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
