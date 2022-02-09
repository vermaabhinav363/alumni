import 'package:alumni/helper/Helperfunction.dart';
import 'package:alumni/helper/constants.dart';
import 'package:alumni/services/auth.dart';
import 'package:alumni/services/database.dart';
import 'package:alumni/views/Verify.dart';
import 'package:alumni/widget/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  _signUpState createState() => _signUpState();
}

late String SignUpEmail;
String text = "";
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
              emailTextEditing.text.replaceAll(" ", ""), passWordTextEditing.text)
          .then((val) {
        if (val == null) {
          setState(() {
            text = "Email already in use";
            showAlertDialog(context);
            isLoading = false;
          });
        } else {
          String result = emailTextEditing.text.substring(0, emailTextEditing.text.indexOf('@'));
          Map<String, String> UserInfoMap = {
            "name": result,
            "email": emailTextEditing.text
          };
          SignUpEmail = emailTextEditing.text;
          HelperFunction.saveUserEmailSharedPreference(emailTextEditing.text);

          HelperFunction.saveUserNameSharedPreference( emailTextEditing.text.substring(0, emailTextEditing.text.indexOf('@')));
          databaseMethods.uploadUserInfo(UserInfoMap);
          Navigator.of(context).popUntil((route) => route.isFirst);

          isLoading = false;
          Constants.myName =  emailTextEditing.text.substring(0, emailTextEditing.text.indexOf('@'));
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Verify()));
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
                      SizedBox(
                        height: 75,
                      ),
                      Container(
                        child: Text("Register with BITS Hyderabad mail only.", style: TextStyle(
                          fontSize: 18,color: Color. fromRGBO(252,81,133, 1.0)
                        ),),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                              child: TextFormField(
                                  validator: (val) {
                                    if (RegExp(
                                            r"^[A-Za-z0-9._%+-]+@hyderabad.bits-pilani.ac.in$")
                                        .hasMatch(val!)) {
                                      return null;
                                    } else {
                                      text = "Use BITS Hyderabad email to register.";
                                      showAlertDialog(context);
                                      text = "";
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
                                      text = "Password has to be 6 chars long";
                                      showAlertDialog(context);
                                      text = "";
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
                        height: 40,
                      ),
                      Container(


                          child: ButtonTheme(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            minWidth: 300.0,
                            height: 50.0,
                            child: RaisedButton(

                              color: Colors.grey,

                              child:Text("Sign Up",style:TextStyle(color: Colors.white)),
                              onPressed: (){
                                signMeUP();

                              },
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
