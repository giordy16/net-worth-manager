import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:net_worth_manager/data/TransactionEntity.dart';
import 'package:net_worth_manager/ui/home/HomePage.dart';
import 'package:net_worth_manager/utils/TextStyles.dart';
import 'package:net_worth_manager/utils/extensions/WidgetCurrency.dart';

import '../../data/ProductEntity.dart';
import '../widgets/TopHeader.dart';
import 'controller/InvestementsController.dart';

class AddTransactionPage extends StatelessWidget {
  ProductEntity product;

  AddTransactionPage(this.product);

  late InvestmentsController controller;

  TextEditingController tickerController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController changeCurrencyController = TextEditingController();
  RxBool sameCurrency = true.obs;

  int lastDateControllerLength = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controller = Get.put(InvestmentsController());

    tickerController.text = product.ticker;
    currencyController.text = product.currency;
    dateController.addListener(onDateTextEdit);

    return Obx(() => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: TopHeader(product.name),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 50,
          margin: const EdgeInsets.all(16),
          child: FilledButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)))),
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                addTransaction();
              }
            },
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add),
                  SizedBox(
                    width: 4,
                  ),
                  Text('Aggiungi')
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
                margin: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Ticker',
                          ),
                          enabled: false,
                          controller: tickerController,
                          validator: (value) {
                            return fieldValidator(value);
                          },
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Valuta strumento',
                          ),
                          enabled: false,
                          controller: currencyController,
                          validator: (value) {
                            return fieldValidator(value);
                          },
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                      "La valuta di acquisto è la stessa dello strumento?",
                                      style: smallTextTS())),
                              Checkbox(
                                  value: sameCurrency.value,
                                  onChanged: (value) {
                                    sameCurrency.value = value!;
                                  })
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        Visibility(
                            visible: !sameCurrency.value,
                            child: Column(
                              children: [
                                TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Valuta di acquisto',
                                    ),
                                    readOnly: true,
                                    controller: changeCurrencyController,
                                    validator: (value) {
                                      return fieldValidator(value);
                                    },
                                    onTap: () {
                                      showCurrencySelector(context, (value) {
                                        changeCurrencyController.value =
                                            TextEditingValue(text: value);
                                      });
                                    },
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true)),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Colors.grey,
                                ),
                              ],
                            )),
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Data di acquisto',
                          ),
                          controller: dateController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            return fieldValidator(value);
                          },
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Prezzo di acquisto',
                            ),
                            controller: priceController,
                            validator: (value) {
                              return fieldValidator(value);
                            },
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true)),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Quantità',
                            ),
                            controller: quantityController,
                            validator: (value) {
                              return fieldValidator(value);
                            },
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true)),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        )));
  }

  Future<void> addTransaction() async {
    await controller.addTransaction(
        TransactionEntity(
            dateController.text,
            double.parse(priceController.text),
            double.parse(quantityController.text),
            sameCurrency.value
                ? currencyController.text
                : changeCurrencyController.text,
            product.ticker),
        product);

    Get.offAll(HomePage(
      initialPage: 1,
    ));
  }

  void onDateTextEdit() {
    if (lastDateControllerLength < dateController.text.length) {
      if (dateController.text.length == 2) {
        dateController.text = "${dateController.text}/";
        dateController.selection =
            TextSelection.collapsed(offset: dateController.text.length);
      } else if (dateController.text.length == 5) {
        dateController.text = "${dateController.text}/";
        dateController.selection =
            TextSelection.collapsed(offset: dateController.text.length);
      }
    }
    lastDateControllerLength = dateController.text.length;
  }

  String? fieldValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Campo obbligatorio";
    }
    return null;
  }
}
