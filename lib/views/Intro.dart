import 'dart:ui';
import 'package:alumni/views/SignUp.dart';
import 'package:alumni/views/SignIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class introduct extends StatefulWidget {
  const introduct({Key? key}) : super(key: key);

  @override
  _introductState createState() => _introductState();
}

class _introductState extends State<introduct> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffb000080),
            elevation: 0,
            bottom: TabBar(
                labelColor: Color(0xffb000080),
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: Colors.white),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("SIGN IN"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("SIGN UP"),
                    ),
                  ),


                ]
            ),
          ),
          body: TabBarView(children: [
            SignIn(),
            signUp(),

          ]),
        )
    );
  }
}
