import 'dart:math';

import 'package:alumni/helper/constants.dart';
import 'package:alumni/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SetCourse extends StatefulWidget {
  const SetCourse({Key? key}) : super(key: key);

  @override
  _SetCourseState createState() => _SetCourseState();
}

DatabaseMethods databaseMethods = new DatabaseMethods();
late Stream<QuerySnapshot> courseStream;

Widget chatRoomList() {
  return StreamBuilder(
      stream: courseStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return ChatRoomTile(snapshot.data.docs[index]["name"],
                          snapshot.data.docs[index]["description"], ds.id);
                    }),
              )
            : Container();
      });
}

class _SetCourseState extends State<SetCourse> {
  initState() {
    databaseMethods.getMyCourse(Constants.myName).then((val) {
      setState(() {
        courseStream = val;
      });
    });
  }
  TextEditingController CourseEditingController = new TextEditingController();
  TextEditingController CourseDescrpEditingController =
  new TextEditingController();
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Set Course for Swap"),
        backgroundColor: Color(0xffb000080),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
                child: Text("Add a new course",
                    style: TextStyle(color: Colors.blue[900], fontSize: 20))),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Container(
                child: new TextField(
                  maxLength: 50,
                  controller: CourseEditingController,
                  decoration:
                      new InputDecoration(labelText: "Enter Course Name"),

                  // Only numbers can be entered
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
              child: Container(
                child: new TextField(
                  maxLength: 100,
                  controller: CourseDescrpEditingController,
                  decoration: new InputDecoration(
                      labelText: "Enter Course Description"),

                  // Only numbers can be entered
                ),
              ),
            ),
            FlatButton(
                color: Colors.grey[200],
                onPressed: () {
                  if(CourseEditingController.text==""){
                    showAlertDialog(context, "Course name can not be empty. ");
                  }else {
                    FirebaseFirestore.instance.collection('Courses').add({
                      'description': CourseDescrpEditingController.text,
                      'name': CourseEditingController.text,
                      'user': Constants.myName,
                    });
                    showAlertDialog(context, "Course added successfully. ");
                  }

                  CourseDescrpEditingController.text = "";
                  CourseEditingController.text = "";
                },
                child: Text("Add",
                    style: TextStyle(color: Colors.blue[900], fontSize: 12))),
            Divider(
              height: 20,
              thickness: 3,
              indent: 20,
              endIndent: 20,
              color: Colors.blue[900],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                child: Text("My courses",
                    style: TextStyle(color: Colors.blue[900], fontSize: 20))),
            SizedBox(
              height: 10,
            ),
            chatRoomList()
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String text) {
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

class ChatRoomTile extends StatelessWidget {
  late final String Name;
  late final String desc;
  late final String id;

  ChatRoomTile(this.Name, this.desc, this.id);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        child: Container(
          color: Colors.grey[200],
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color:
                          Color(Random().nextInt(0xffffffff)).withAlpha(0xff),
                      borderRadius: BorderRadius.circular(40)),
                  child: Name!=""?Text(
                    "${Name.substring(0, 1)}".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ):Text("")),
              SizedBox(
                width: 8,
              ),
              Flexible(
                  child: Text(
                Name + " - ",
              )),
              Flexible(
                  child: Text(
                desc,
              )),
              IconButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("Courses")
                      .doc(id )
                      .delete();
                },
                icon: Icon(Icons.delete),
              )
            ],
          ),
        ),
      ),
    );
  }
}
