import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
      title: Container(
    decoration: BoxDecoration(),
    child: Center(
        child: GradientText("",
            gradient: LinearGradient(colors: [Colors.blue, Colors.white]),
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center)),
  ));
}

InputDecoration Tex(String hint) {
  return InputDecoration(

    hintText: hint,
    hintStyle: TextStyle(),
    border: OutlineInputBorder(),
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.black);
}
