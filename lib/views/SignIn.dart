import 'package:alumni/helper/Helperfunction.dart';
import 'package:alumni/helper/constants.dart';
import 'package:alumni/services/auth.dart';
import 'package:alumni/services/database.dart';
import 'package:alumni/views/ForgotPassword.dart';
import 'package:alumni/views/SearchOrAddItems.dart';
import 'package:alumni/views/Verify.dart';
import 'package:alumni/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

void initState() {
  isLoading = false;
}


String text = "";
final formKey = GlobalKey<FormState>();
bool isLoading = false;
TextEditingController emailTextEditing = new TextEditingController();
TextEditingController passWordTextEditing = new TextEditingController();
AuthMethods authMethods = new AuthMethods();
DatabaseMethods databaseMethods = new DatabaseMethods();

class _SignInState extends State<SignIn> {
  signMeIN() async {
    FirebaseApp app = await Firebase.initializeApp();

    setState(() {
      isLoading = true;
    });
    authMethods
        .signInWithEmail(
            emailTextEditing.text.replaceAll(" ", ""), passWordTextEditing.text)
        .then((val) {
      if (val == null) {
        setState(() {
          text =
              "Wrong Credentials used or one or more text field is missing. Please try again. ";
          showAlertDialog(context);
          setState(() {
            isLoading = false;
          });
        });
      } else {


        HelperFunction.saveUserNameSharedPreference(emailTextEditing.text
            .substring(0, emailTextEditing.text.indexOf('@')));
        HelperFunction.saveUserEmailSharedPreference(emailTextEditing.text);

        Navigator.of(context).popUntil((route) => route.isFirst);

        isLoading = false;
        User? user = FirebaseAuth.instance.currentUser;
        if (user!.emailVerified) {
          HelperFunction.saveUserNameSharedPreference(emailTextEditing.text
              .substring(0, emailTextEditing.text.indexOf('@')));
          Constants.myName = emailTextEditing.text
              .substring(0, emailTextEditing.text.indexOf('@'));
          HelperFunction.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SearchAdd()));
        } else {
          Constants.myName = emailTextEditing.text
              .substring(0, emailTextEditing.text.indexOf('@'));
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Verify()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: Center(child: CircularProgressIndicator()),
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: Column(
                  children: [
                    Container(
                      child: RichText(
                        text: TextSpan(
                          text: 'New User?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          children: [
                            TextSpan(
                              text: ' Swipe right ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.pink,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 75,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                      child: TextField(
                          controller: emailTextEditing,
                          style: simpleTextStyle(),
                          decoration: Tex("Email")),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                      child: TextField(
                          obscureText: true,
                          controller: passWordTextEditing,
                          decoration: Tex("Password")),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ForgotPass()));
                        },
                        child: Text(
                          "Forgot your logging details? Get help logging in.",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.pink,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(

                        child: ButtonTheme(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          minWidth: 300.0,
                          height: 50.0,
                          child: RaisedButton(
                            color: Colors.grey,
                            child: Text("Sign In",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              signMeIN();
                            },
                          ),
                        )),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      //title: Text(""),
      content: Text("$text"),
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
