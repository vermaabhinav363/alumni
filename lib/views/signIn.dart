import 'package:alumni/helper/herperfunction.dart';
import 'package:alumni/services/auth.dart';
import 'package:alumni/services/database.dart';
import 'package:alumni/views/ChatRoom.dart';
import 'package:alumni/views/SearchOrAddItems.dart';
import 'package:alumni/widget/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}
void initState(){
  isLoading   = false;
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
class _SignInState extends State<SignIn> {

  signMeIN() async {
    FirebaseApp app = await Firebase.initializeApp();

      setState(() {
        isLoading = true;
      });
      authMethods
          .signInWithEmail(
          emailTextEditing.text, passWordTextEditing.text)
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


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
      child: Center(child: CircularProgressIndicator()),
    )
        : Container(

      height: MediaQuery
          .of(context)
          .size
          .height,
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
              SizedBox(height: 135,),
              Container(
                padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                child: TextField(
                    controller: emailTextEditing,
                    style: simpleTextStyle(), decoration: Tex("Email")),
              ),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                child: TextField(controller: passWordTextEditing,decoration: Tex("Password")),
              ),


              SizedBox(
                height: 80,
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(25),
                    color: Colors.green,

                  ),
                  child: GestureDetector(
                    onTap: (){
                      signMeIN();
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 20, color: Colors.white),
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
