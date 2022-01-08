
import 'package:alumni/helper/herperfunction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAd extends StatefulWidget {
  const MyAd({Key? key}) : super(key: key);

  @override
  _MyAdState createState() => _MyAdState();
}

class _MyAdState extends State<MyAd> {
  late String str;
  void initial() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      str = prefs.getString('USEREMAILKEY');
      print(str);
    });
  }
  //final Future<QuerySnapshot<Map<String, dynamic>>> _usersStream = FirebaseFirestore.instance.collection("URL_Br_Year_Name_Price_Email").where('Email', isEqualTo: str).get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),

    );
  }
}
