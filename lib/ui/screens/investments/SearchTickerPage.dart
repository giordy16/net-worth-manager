// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:net_worth_manager/ui/investments/controller/InvestementsController.dart';
// import 'package:net_worth_manager/ui/widgets/SearchMarketItem.dart';
//
// import '../widgets/TopHeader.dart';
//
// class SearchTickerPage extends StatelessWidget {
//
//   TextEditingController searchController = TextEditingController();
//   final InvestmentsController controller = Get.put(InvestmentsController());
//
//   @override
//   Widget build(BuildContext context) {
//     searchController.addListener(onTextChange);
//
//     return Obx(
//       () => Scaffold(
//           appBar: TopHeader('Ricerca'),
//           body: SafeArea(
//             child: Container(
//                 margin: EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     CupertinoTextField(
//                       autofocus: true,
//                       prefix: Container(
//                         child: Icon(
//                           Icons.search,
//                           color: Colors.grey,
//                         ),
//                         margin: EdgeInsets.only(left: 8),
//                       ),
//                       controller: searchController,
//                       clearButtonMode: OverlayVisibilityMode.editing,
//                       placeholder: 'Name, ticker, ISIN, ...',
//                     ),
//                     SizedBox(height: 8),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: controller.tickerSearchResult.length,
//                         itemBuilder: (context, index) {
//                           var item = controller.tickerSearchResult[index];
//                           return SearchMarketWidget(item);
//                         },
//                       ),
//                     )
//                   ],
//                 )),
//           )),
//     );
//   }
//
//   void onTextChange() {
//     searchController.removeListener(onTextChange);
//
//     Future.delayed(const Duration(milliseconds: 2000), () {
//       searchController.addListener(onTextChange);
//       if (searchController.text.isNotEmpty) {
//         controller.tickerSearch(searchController.text);
//       }
//     });
//   }
// }
