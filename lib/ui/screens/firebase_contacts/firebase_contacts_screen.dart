import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_text_field.dart';

import '../../../i18n/strings.g.dart';
import '../../widgets/base_components/app_bottom_fab.dart';
import '../../widgets/modal/user_message.dart';

enum FirebaseScreenType { suggestions, reports, contacts }

extension FirebaseType on FirebaseScreenType {
  String get title {
    switch (this) {
      case FirebaseScreenType.suggestions:
        return t.suggest_feature;
      case FirebaseScreenType.reports:
        return t.report_a_problem;
      case FirebaseScreenType.contacts:
        return t.contact_us;
    }
  }

  String get firebaseCollection {
    switch (this) {
      case FirebaseScreenType.suggestions:
        return "feature_suggestions";
      case FirebaseScreenType.reports:
        return "report_problem";
      case FirebaseScreenType.contacts:
        return "contact_us";
    }
  }
}

class FirebaseContactsScreen extends StatelessWidget {
  static String path = "/FirebaseContactsScreen";

  FirebaseScreenType type;

  FirebaseContactsScreen(this.type);

  final _formKey = GlobalKey<FormState>();

  String userMail = "";
  String message = "";

  void sendMessage(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final firebaseModel = {
        "sender": userMail,
        "message": message,
      };

      final db = FirebaseFirestore.instance;
      db.collection(type.firebaseCollection).add(firebaseModel);

      UserMessage.showMessage(
          context, t.firebase_feedback_message);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(type.title)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            AppBottomFab(text: t.send, onTap: () => sendMessage(context)),
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.screenMargin),
              child: Column(
                children: [
                  AppTextField(
                      title: t.your_email,
                      isMandatory: true,
                      keyboardType: TextInputType.emailAddress,
                      onTextChange: (message) {
                        this.userMail = message;
                      }),
                  SizedBox(height: 16),
                  Expanded(
                    child: AppTextField(
                        title: t.message,
                        isMandatory: true,
                        expandedMode: true,
                        keyboardType: TextInputType.multiline,
                        onTextChange: (message) {
                          this.message = message;
                        }),
                  ),
                  SizedBox(height: 80)
                ],
              ),
            ),
          ),
        ));
  }
}
