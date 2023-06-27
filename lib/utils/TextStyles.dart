import 'package:flutter/material.dart';

TextStyle subTitleTS() {
  return TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
}

TextStyle normalTextTS() {
  return TextStyle(fontSize: 16, color: Colors.black);
}

TextStyle normalTextColoredTS(double num) {
  return TextStyle(fontSize: 16, color: num < 0 ? Colors.red : Colors.green);
}

TextStyle normalBoldTextTS() {
  return TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);
}

TextStyle smallTextTS() {
  return TextStyle(fontSize: 14, color: Colors.black);
}

TextStyle smallGreyTextTS() {
  return TextStyle(fontSize: 14, color: Colors.grey);
}

TextStyle smallTextColoredTS(double num) {
  return TextStyle(fontSize: 14, color: num < 0 ? Colors.red : Colors.green);
}

TextStyle smallWhiteTextTS() {
  return TextStyle(fontSize: 14, color: Colors.white);
}
