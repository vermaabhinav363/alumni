import 'dart:io';
import 'dart:ui';
import 'package:alumni/helper/Helperfunction.dart';
import 'package:alumni/helper/constants.dart';
import 'package:alumni/views/SearchOrAddItems.dart';
import 'package:alumni/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';



class Add2 extends StatelessWidget {
  const Add2({Key? key}) : super(key: key);

  static const String _title = 'Add Item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: const Center(
        child: MyStatefulWidget(),
      ),
    );

  }
}

bool isLoading = false;
TextEditingController NameTextEditing = new TextEditingController();
TextEditingController PriceTextEditing = new TextEditingController();


class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _index = 0;
  String ImageUrl = "test";
  late double price=0;
  late String formattedDate;
  late String email;
  initState(){
    getUserInfo();
    email = Constants.myName;
    print(email);

  }
  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPreference();
  }
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
      child: Center(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                ),
                CircularProgressIndicator(),
                SizedBox(
                  height: 30,
                ),
                Text("Loading your image. This may take a while."),
              ],
            ),
          )),
    )
        : Stepper(
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index <= 2) {
          setState(() {
            _index += 1;
          });
        }
        else if(_index==3 && ImageUrl !="test"){
          if(PriceTextEditing.text == '0'){
            PriceTextEditing.text="Negotiable";}
          FirebaseFirestore.instance
              .collection('URL_Br_Year_Name_Price_Email')
              .add({
            'Branch': 'Misc.',
            'Name':NameTextEditing.text,
            'Price':PriceTextEditing.text,
            'Semester':'Misc.',
            'URL':ImageUrl,
            'Email': email,

          });
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => SearchAdd()));


        }
        else if(_index==3 && ImageUrl =="test"){
            showAlertDialog(context, "Please add an image. ");
        }
      }
      ,
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        Step(
          title: const Text('Add Pic'),
          content: Container(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Column(
                  children: [
                    (ImageUrl != "test")
                        ? Image.network(ImageUrl)
                        : Placeholder(
                      fallbackHeight: 200,
                      fallbackWidth: double.infinity,
                    ),
                    (ImageUrl == "test")
                        ? RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        UploadImage();
                      },
                      child: Text("Capture Image"),
                    )
                        : RaisedButton(
                      onPressed: () {
                        setState(() {
                          ImageUrl = "test";
                        });
                        ;
                      },
                      child: Text("Delete Image"),
                    ),
                    Text(
                      'Loading may take some time.',
                      style: TextStyle(color: Colors.blue[900],fontSize: 12),
                    )
                  ],
                ),
              )),
        ),
        Step(
          title: Text('Set Price'),
          content: Column(
            children: [
              Container(
                child: new TextField(
                  controller: PriceTextEditing,
                  decoration: new InputDecoration(labelText: "Enter Price"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                ),
              ),
              SizedBox(height: 25,),
              Center(
                child: Text(
                  'Leave blank if you want price to be negotiable. ',
                  style: TextStyle(color: Colors.blue[900],fontSize: 12),
                ),
              )
            ],
          ),
        ),
        Step(
          title: Text('Description'),
          content: TextField(
              maxLength: 150,
              controller: NameTextEditing,
              style: simpleTextStyle(), decoration: Tex("")),
        ),
        Step(
          title: Text('Confirm'),
          content: Text("You are all set to go." , style: TextStyle(color:Colors.blue[900],fontWeight: FontWeight.bold),),
        ),

      ],
    );
  }

  UploadImage() async {
    //Check Permission
    final storage = FirebaseStorage.instance;
    final picker = ImagePicker();
    PickedFile image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = (await picker.getImage(source: ImageSource.camera))!;
      setState(() {
        isLoading = true;
      });
      var file = File(image.path);
      if (image != null) {
        //Upload Image
        DateTime now = DateTime.now();

        formattedDate = (now.year.toString() +
            now.month.toString() +
            now.day.toString() +
            now.hour.toString() +
            now.minute.toString() +
            now.second.toString());

        var snap = await storage.ref().child(formattedDate).putFile(file);
        var downloadedURL = await snap.ref.getDownloadURL();
        setState(() {
          ImageUrl = downloadedURL;
          isLoading = false;
        });
      } else {
        setState(() {

          isLoading = false;
        });
      }
    } else {
      setState(() {

        isLoading = false;
      });
    }
  }
  showAlertDialog(BuildContext context,String text) {
    AlertDialog alert = AlertDialog(
      //title: Text(""),
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
