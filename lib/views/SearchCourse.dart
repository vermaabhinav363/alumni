import 'dart:math';

import 'package:alumni/helper/constants.dart';
import 'package:alumni/services/database.dart';
import 'package:alumni/views/Conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchCourse extends StatefulWidget {
  const SearchCourse({Key? key}) : super(key: key);

  @override
  _SearchCourseState createState() => _SearchCourseState();
}

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
                          snapshot.data.docs[index]["description"], snapshot.data.docs[index]["user"],ds.id);
                    }),
              )
            : Container();
      });
}
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

DatabaseMethods databaseMethods = new DatabaseMethods();
late Stream<QuerySnapshot> courseStream;

class _SearchCourseState extends State<SearchCourse> {
  initState() {
    databaseMethods.getAllCourse(Constants.myName).then((val) {
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
        title: Text("Available  Courses for Swap"),
        backgroundColor: Color(0xffb000080),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),

            Container(
                child: Text("Courses",
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

}

class ChatRoomTile extends StatelessWidget {
  late final String Name;
  late final String desc;
  late final String user;
  late final String id;

  ChatRoomTile(this.Name, this.desc, this.user,this.id);

  @override
  Widget build(BuildContext context) {
    createChatRoomAndStartConversation(String userName){
      List<String> users = [userName, Constants.myName];
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      Map<String, dynamic> chatRoomMap = {
        "chatroomId": chatRoomId,
        "users": users,
      };

      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Conversation(chatRoomId)));
    }
    return GestureDetector(
      onTap: () {
        print(user);
        createChatRoomAndStartConversation(user);
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
              Constants.myName=="vermaabhinav363"?IconButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("Courses")
                      .doc(id as String)
                      .delete();
                },
                icon: Icon(Icons.delete),
              ):Container()

            ],
          ),
        ),
      ),
    );
  }
}
