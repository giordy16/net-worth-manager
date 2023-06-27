import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:net_worth_manager/data/TransactionEntity.dart';
import 'package:net_worth_manager/data/enum/TransactionTypeEnum.dart';
import 'package:net_worth_manager/ui/home/HomePage.dart';
import 'package:net_worth_manager/utils/TextStyles.dart';
import 'package:net_worth_manager/utils/extensions/CupertinoExtension.dart';

import '../../data/ProductEntity.dart';
import '../widgets/TopHeader.dart';
import 'controller/InvestementsController.dart';

class AddTransactionPage extends StatelessWidget {
  ProductEntity product;
  TransactionEntity? transaction;
  bool? showTransactionType;

  AddTransactionPage(this.product,
      {this.transaction = null, this.showTransactionType = false});

  InvestmentsController controller = Get.put(InvestmentsController());

  TextEditingController tickerController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController currencyChangeController = TextEditingController();
  TextEditingController transactionTypeController = TextEditingController();

  TransactionTypeEnum transactionType = TransactionTypeEnum.BUY;
  RxBool sameCurrency = true.obs;

  int lastDateControllerLength = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    tickerController.text = product.ticker;
    currencyController.text = product.currency;
    dateController.text = transaction?.date ?? "";
    priceController.text = transaction?.price.toString() ?? "";
    quantityController.text = transaction?.qt.toString() ?? "";
    currencyChangeController.text =
        transaction?.currencyChange.toString() ?? "";
    transactionTypeController.text = transactionType.name.capitalizeFirst!;
    sameCurrency.value =
        transaction == null || transaction?.currencyChange == 1;

    dateController.addListener(onDateTextEdit);

    return Obx(() => Scaffold(
        appBar: TopHeader(product.name, actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.delete))
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: Container(
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
                child: transaction == null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add),
                          SizedBox(
                            width: 4,
                          ),
                          Text('Aggiungi')
                        ],
                      )
                    : Text('Modifica'),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
                margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                                      "La valuta della transazione è la stessa "
                                      "dello strumento?",
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
                                      labelText: 'Tasso di cambio',
                                    ),
                                    controller: currencyChangeController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    validator: (value) {
                                      return fieldValidator(value);
                                    }),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Colors.grey,
                                ),
                              ],
                            )),
                        Visibility(
                            visible: showTransactionType == true,
                            child: Column(
                              children: [
                                TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Tipologia',
                                    ),
                                    readOnly: true,
                                    controller: transactionTypeController,
                                    validator: (value) {
                                      return fieldValidator(value);
                                    },
                                    onTap: () {
                                      showTransactionTypeChooser(context);
                                    }),
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
                            labelText: 'Data',
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
                              labelText: 'Prezzo',
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
    if (transaction != null) {
      await controller.updateTransaction(TransactionEntity(
          id: transaction!.id,
          dateController.text,
          double.parse(priceController.text),
          double.parse(quantityController.text),
          sameCurrency.value
              ? 1.0
              : double.parse(currencyChangeController.text),
          product.ticker,
          transactionType));
    } else {
      await controller.addTransaction(
          TransactionEntity(
              dateController.text,
              double.parse(priceController.text),
              double.parse(quantityController.text),
              sameCurrency.value
                  ? 1.0
                  : double.parse(currencyChangeController.text),
              product.ticker,
              transactionType),
          product);
    }

    if (showTransactionType == true) {
      // from other pages
      Get.back(result: 'update');
    } else {
      // from home page
      Get.offAll(() => HomePage(
            initialPage: 1,
          ));
    }
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

  void showTransactionTypeChooser(BuildContext context) {
    showCupertinoBottomSelection(context, "Seleziona la tipologia",
        TransactionTypeEnum.values.map((e) => e.name.capitalizeFirst!).toList(),
        (value) {
      transactionTypeController.text = value;
      transactionType = TransactionTypeEnum.values.byName(value.toUpperCase());
    });
  }

  String? fieldValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Campo obbligatorio";
    }
    return null;
  }
}
