import 'package:alumni/views/ChatRoom.dart';
import 'package:alumni/views/MyAd.dart';
import 'package:alumni/views/SearchOrAddItems.dart';
import 'package:alumni/views/SignUp.dart';
import 'package:alumni/views/intro.dart';
import 'package:alumni/views/search.dart';
import 'package:alumni/views/signIn.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/signUp': (context) => signUp(),
        '/signIN': (context) => SignIn(),
        '/chat': (context) => ChatRoom(),
        '/search':(context) =>SearchScreen(),
        '/MyAd':(context) => MyAd(),
        '/Search':(context)=>SearchAdd(),
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: introduct(),
    );
  }
}

