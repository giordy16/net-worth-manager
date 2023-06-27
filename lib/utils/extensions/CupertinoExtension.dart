import 'package:flutter/cupertino.dart';
import 'package:forex_conversion/forex_conversion.dart';
import 'package:get/get.dart';

extension CupertinoExtension on StatelessWidget {
  Future<void> showCurrencySelector(BuildContext context,
      String? selectedCurrency, Function(String) onCurrencyConfirm) async {
    final fx = Forex();
    List<String> availableCurrencies = await fx.getAvailableCurrencies();
    availableCurrencies.sort((a, b) => a.compareTo(b));

    int currentItem = 0;

    if (selectedCurrency != null && selectedCurrency.isNotEmpty) {
      currentItem = availableCurrencies.indexOf(selectedCurrency);
    }

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                        child: Text("Annulla"),
                        onPressed: () {
                          Get.back();
                        }),
                    CupertinoButton(
                        child: Text("Conferma"),
                        onPressed: () {
                          onCurrencyConfirm(availableCurrencies[currentItem]);
                          Get.back();
                        })
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32,
                    scrollController: FixedExtentScrollController(
                      initialItem: currentItem,
                    ),
                    onSelectedItemChanged: (int selectedItem) {
                      currentItem = selectedItem;
                    },
                    children: List<Widget>.generate(availableCurrencies.length,
                        (int index) {
                      return Center(child: Text(availableCurrencies[index]));
                    }),
                  ),
                )
              ],
            )),
      ),
    );
  }

  showCupertinoBottomSelection(BuildContext context, String title,
      List<String> list, Function(String) onSelection) {
    if (list.isEmpty) return;

    List<CupertinoActionSheetAction> actionsList = [];
    list.forEach((element) {
      actionsList.add(CupertinoActionSheetAction(
          onPressed: () {
            onSelection(element);
            Get.back();
          },
          child: Text(element)));
    });
    actionsList.add(CupertinoActionSheetAction(
      isDestructiveAction: true,
      onPressed: () {
        Get.back();
      },
      child: Text('Annulla'),
    ));

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(title),
        actions: actionsList
      ),
    );
  }
}
