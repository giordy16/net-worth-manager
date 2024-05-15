// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:net_worth_manager/data/TransactionEntity.dart';
// import 'package:net_worth_manager/data/enum/TransactionTypeEnum.dart';
// import 'package:net_worth_manager/ui/investments/component/ProductHistoryItem.dart';
// import 'package:net_worth_manager/utils/extensions/number_extension.dart';
//
// import '../../data/MarketPosition.dart';
// import '../../utils/TextStyles.dart';
// import '../widgets/TopHeader.dart';
// import 'AddTransactionPage.dart';
// import 'controller/InvestementsController.dart';
//
// class MarketPoistionPage extends StatelessWidget {
//   MarketPosition position;
//
//   MarketPoistionPage(this.position);
//
//   final controller = Get.put(InvestmentsController());
//   late Rx<MarketPosition> rxPosition;
//
//   @override
//   Widget build(BuildContext context) {
//     rxPosition = position.obs;
//
//     Rx<String> avgPrice = "".obs;
//     Rx<String> performance = "".obs;
//
//     position
//         .getAvgPriceOnUserCurrency()
//         .then((value) => avgPrice.value = value.formatted());
//
//     position
//         .getPerformanceOnUserCurrency()
//         .then((value) => performance.value = value.formatted());
//
//     return Obx(() => Scaffold(
//         appBar: TopHeader(rxPosition.value.product.name),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Container(
//                 margin: EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Container(
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Container(
//                           padding: EdgeInsets.all(16),
//                           width: double.infinity,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Il tuo investimento',
//                                 style: subTitleTS(),
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text("${rxPosition.value.getTotQt()} azioni",
//                                       style: normalTextTS()),
//                                   Text(
//                                       rxPosition.value
//                                           .getCurrentValueOnUserCurrency()
//                                           .formatted(),
//                                       style: normalBoldTextTS())
//                                 ],
//                               ),
//                               Container(
//                                   margin: EdgeInsets.symmetric(vertical: 16),
//                                   height: 1,
//                                   width: double.infinity,
//                                   color: Colors.black.withOpacity(.2)),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text("Prezzo medio di acquisto",
//                                       style: normalTextTS()),
//                                   Text(avgPrice.value, style: normalTextTS())
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text("Prezzo attuale", style: normalTextTS()),
//                                   Text(
//                                       rxPosition
//                                           .value.product.lastPriceOnUserCurrency
//                                           .formatted(),
//                                       style: normalTextTS())
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Profitto", style: normalTextTS()),
//                                   Text(
//                                     "${performance.value}"
//                                     "\n(${rxPosition.value.getPerformancePerc().formattedPerc()})",
//                                     style: normalTextColoredTS(
//                                         rxPosition.value.getPerformancePerc()),
//                                     textAlign: TextAlign.end,
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Container(
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Container(
//                           padding: EdgeInsets.all(16),
//                           width: double.infinity,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Transazioni',
//                                 style: subTitleTS(),
//                               ),
//                               SizedBox(height: 8),
//                               TransactionList(),
//                               CupertinoButton(
//                                 onPressed: () {
//                                   onAddTransaction();
//                                 },
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: const [
//                                       Icon(Icons.add),
//                                       SizedBox(
//                                         width: 4,
//                                       ),
//                                       Text('Aggiungi')
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 )),
//           ),
//         )));
//   }
//
//   Widget TransactionList() {
//     return ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: rxPosition.value.transactionsList.length,
//         itemBuilder: (context, index) {
//           var transaction = rxPosition.value.transactionsList[index];
//           return ProductHistoryItem(
//             transaction,
//             index == rxPosition.value.transactionsList.length - 1,
//             onTransactionClick,
//             transactionPerformance: transaction.type == TransactionTypeEnum.BUY
//                 ? rxPosition.value.getPerformanceOfTransaction(transaction)
//                 : null,
//           );
//         });
//   }
//
//   Future<void> onAddTransaction() async {
//     var result = await Get.to(() => AddTransactionPage(rxPosition.value.product,
//         showTransactionType: true));
//     onResume(result);
//   }
//
//   Future<void> onTransactionClick(TransactionEntity transaction) async {
//     var result = await Get.to(() => AddTransactionPage(
//           rxPosition.value.product,
//           transaction: transaction,
//           showTransactionType: true,
//         ));
//     onResume(result);
//   }
//
//   Future<void> onResume(dynamic result) async {
//     if (result == 'update') {
//       rxPosition.value.updateTransactionList(await controller
//           .getAllTransactionByProduct(rxPosition.value.product));
//       rxPosition.refresh();
//     }
//   }
// }
