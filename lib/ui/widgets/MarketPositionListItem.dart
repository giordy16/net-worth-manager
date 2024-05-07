// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:net_worth_manager/data/MarketPosition.dart';
// import 'package:net_worth_manager/utils/extensions/NumberExtension.dart';
//
// import '../../utils/TextStyles.dart';
// import '../investments/MarketPositionPage.dart';
//
// class MarketPositionListItem extends StatelessWidget {
//   MarketPosition position;
//   Function onBackFromClick;
//   bool isLast;
//
//   MarketPositionListItem(this.position, this.onBackFromClick,
//       {super.key, this.isLast = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoButton(
//       padding: EdgeInsets.zero,
//       onPressed: () async {
//         await Get.to(() => MarketPoistionPage(position));
//         onBackFromClick();
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     position.product.name,
//                     style: normalTextTS(),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                   ),
//                 ),
//                 SizedBox(width: 4),
//                 Text(position.getCurrentValueOnUserCurrency().formatted(),
//                     style: subTitleTS())
//               ],
//             ),
//             SizedBox(height: 4),
//             Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(position.product.ticker, style: smallTextTS()),
//                   Text(("${position.getPerformancePerc().formattedPerc()}"),
//                       style: smallTextColoredTS(position.getPerformancePerc())),
//                 ]),
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
