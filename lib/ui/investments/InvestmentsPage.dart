import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_worth_manager/ui/investments/SearchTickerPage.dart';

import '../../data/MarketPosition.dart';
import '../../utils/TextStyles.dart';
import '../widgets/MarketPositionListItem.dart';
import 'controller/InvestementsController.dart';

class InvestmentsPage extends StatelessWidget {
  InvestmentsController controller = Get.put(InvestmentsController());

  @override
  Widget build(BuildContext context) {
    controller.getAllPositions();

    return Obx(() => Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => SearchTickerPage());
            },
            child: Icon(Icons.add),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 80),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Valore attuale',
                              style: subTitleTS(),
                            ),
                            Text(
                              controller.getTotalInvestmentsValue(),
                              style: normalTextTS(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rendimento',
                              style: subTitleTS(),
                            ),
                            Text(
                              '?',
                              style: normalTextTS(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: buildPositions(controller.marketPositionList)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  List<Widget> buildPositions(List<MarketPosition> marketPositionList) {
    List<Widget> listToReturn = [];
    listToReturn.add(Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Posizioni',
          style: subTitleTS(),
        ),
        IconButton(onPressed: () {
          controller.refreshAllPrices();
        }, icon: Icon(Icons.refresh))
      ],
    ));

    for (int i = 0; i < marketPositionList.length; i++) {
      listToReturn.add(MarketPositionListItem(marketPositionList[i],
          isLast: i == marketPositionList.length - 1));
    }

    return listToReturn;
  }
}
