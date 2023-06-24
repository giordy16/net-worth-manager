import 'package:flutter/cupertino.dart';
import 'package:forex_conversion/forex_conversion.dart';
import 'package:get/get.dart';

extension NumberExtension on StatelessWidget {
  Future<void> showCurrencySelector(
      BuildContext context, Function(String) onCurrencyConfirm) async {

    final fx = Forex();
    List<String> availableCurrencies = await fx.getAvailableCurrencies();
    availableCurrencies.sort((a, b) => a.compareTo(b));

    int currentItem = 0;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(child: Text("Annulla"), onPressed: () {
                      Get.back();
                    }),
                    CupertinoButton(child: Text("Conferma"), onPressed: () {
                      onCurrencyConfirm(availableCurrencies[currentItem]);
                      Get.back();
                    })
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32,
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
}
