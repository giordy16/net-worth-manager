// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:net_worth_manager/data/TransactionEntity.dart';
// import 'package:net_worth_manager/utils/extensions/number_extension.dart';
//
// import '../../../utils/TextStyles.dart';
//
// class ProductHistoryItem extends StatelessWidget {
//   TransactionEntity transaction;
//   Function(TransactionEntity) onTap;
//   bool isLast;
//   double? transactionPerformance;
//
//   ProductHistoryItem(this.transaction, this.isLast, this.onTap,
//       {this.transactionPerformance = null});
//
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoButton(
//       padding: EdgeInsets.zero,
//       onPressed: () {
//         onTap(transaction);
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(transaction.type.name.capitalizeFirst!,
//                         style: normalTextTS()),
//                     Text(transaction.date, style: smallGreyTextTS())
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(transaction.getTotalCostOnAssetCurrency().formatted(),
//                         style: normalTextTS()),
//                     if (transactionPerformance != null)
//                       Text(transactionPerformance!.formattedPerc(),
//                           style: normalTextColoredTS(transactionPerformance!)),
//                   ],
//                 )
//               ],
//             ),
//             Visibility(
//                 visible: !isLast,
//                 child: Column(
//                   children: [
//                     SizedBox(height: 16),
//                     Container(
//                         height: 1,
//                         width: double.infinity,
//                         color: Colors.black.withOpacity(.2))
//                   ],
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }
