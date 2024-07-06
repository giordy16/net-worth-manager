import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/screens/general_selection/general_selection_params.dart';
import 'package:net_worth_manager/ui/widgets/app_divider.dart';

class GeneralSelection extends StatelessWidget {
  static String path = "/GeneralSelection";


  GeneralSelectionParams params;

  GeneralSelection(this.params);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select"),
      ),
      body: SafeArea(
        child: ListView.separated(
            itemBuilder: (context, index) {
              return Material(
                child: InkWell(
                  onTap: () {
                    context.pop(params.items[index]);
                  },
                  child: ListTile(
                      trailing: (params.initialValue != null &&
                              params.initialValue == params.items[index])
                          ? const Icon(Icons.check)
                          : null,
                      title: Text(params.items[index].toString())),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
                child: AppDivider(),
              );
            },
            itemCount: params.items.length),
      ),
    );
  }
}
