import 'package:alumni/services/auth.dart';
import 'package:alumni/services/database.dart';
import 'package:alumni/views/Intro.dart';
import 'package:alumni/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}
late String text;
TextEditingController EmailTextEditing = new TextEditingController();
AuthMethods authMethods = new AuthMethods();
DatabaseMethods databaseMethods = new DatabaseMethods();

class _ForgotPassState extends State<ForgotPass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffb000080),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                "Find Your Account. ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                "Enter your email linked to your account ",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              alignment: Alignment.center,
              color: Colors.white,
              child: TextField(
                  controller: EmailTextEditing, decoration: Tex("Email")),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: GestureDetector(
                onTap: () async {
                  FirebaseApp app = await Firebase.initializeApp();
                   if (EmailTextEditing.text != null ) {
                    if(true)
                    {
                     var v = authMethods.resetPassword(EmailTextEditing.text);
                     print(v);
                      showAlertDialog(context, "Email has been sent");
                    } else {
                    showAlertDialog(context,
                        "Failed to sent recovery email. Please confirm whether you have registered or not. ");
                  }
                }
                  else{
                    showAlertDialog(context, "Text field empty. ");
                  }
                },

                child: Text(
                  "Send recovery email",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
          )

          ]),
        ),
      ),
    );
  }
  showAlertDialog(BuildContext context,String text) {
    AlertDialog alert = AlertDialog(

      content: Text(text),
      actions: [],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
