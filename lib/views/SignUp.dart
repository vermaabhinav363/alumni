import 'package:alumni/helper/herperfunction.dart';
import 'package:alumni/services/auth.dart';
import 'package:alumni/services/database.dart';
import 'package:alumni/views/ChatRoom.dart';
import 'package:alumni/views/SearchOrAddItems.dart';
import 'package:alumni/widget/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  _signUpState createState() => _signUpState();
}

String text =
    "";
final formKey = GlobalKey<FormState>();
bool isLoading = false;
TextEditingController userNameTextEditing = new TextEditingController();
TextEditingController emailTextEditing = new TextEditingController();
TextEditingController passWordTextEditing = new TextEditingController();
AuthMethods authMethods = new AuthMethods();
DatabaseMethods databaseMethods = new DatabaseMethods();

class _signUpState extends State<signUp> {
  signMeUP() async {
    FirebaseApp app = await Firebase.initializeApp();
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEnailandPassword(
              emailTextEditing.text, passWordTextEditing.text)
          .then((val) {
        if (val == null) {
          setState(() {
            text =
            "Email already in use";
            showAlertDialog(context);
            isLoading = false;
          });
        }
        else {
          print('${val.userId}');
          Map<String, String> UserInfoMap = {
            "name": userNameTextEditing.text,
            "email": emailTextEditing.text
          };
          HelperFunction.saveUserEmailSharedPreference(emailTextEditing.text);
          HelperFunction.saveUserNameSharedPreference(userNameTextEditing.text);
          databaseMethods.uploadUserInfo(UserInfoMap);
          HelperFunction.saveUserLoggedInSharedPreference(true);
          Navigator.of(context).popUntil((route) => route.isFirst);

          isLoading = false;

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => SearchAdd()));

        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
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
                            text: 'Already have an account?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            children: [


                              TextSpan(
                                text: ' Swipe left ',
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
                      SizedBox(height: 75,),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                              child: TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty || val.length < 4) {
                                      text =
                                          "UserName must be atleast of 4 char";
                                      showAlertDialog(context);
                                      text =
                                          "";
                                      return "";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: userNameTextEditing,
                                  style: simpleTextStyle(),
                                  decoration: Tex("User Name")),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                              child: TextFormField(
                                  validator: (val) {
                                    if (RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)) {
                                      return null;
                                    } else {
                                      text = "Use a valid email pattern";
                                      showAlertDialog(context);
                                      text =
                                          "";
                                      return "";
                                    }
                                  },
                                  controller: emailTextEditing,
                                  style: simpleTextStyle(),
                                  decoration: Tex("Email")),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                              child: TextFormField(
                                  obscureText: true,
                                  validator: (val) {
                                    if (val!.isEmpty || val.length < 6) {
                                      text = "Password has to be 6 char";
                                      showAlertDialog(context);
                                      text =
                                          "";
                                      return "";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: passWordTextEditing,
                                  style: simpleTextStyle(),
                                  decoration: Tex("Password")),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius:BorderRadius.circular(25),
                            color: Colors.green,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              signMeUP();
                            },
                            child: Container(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(fontSize: 20,color: Colors.white),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),



                    ],
                  ),
                ),
              ),
            ),
    );
  }
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
