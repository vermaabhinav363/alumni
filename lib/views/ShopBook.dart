import 'dart:ui';

import 'package:alumni/helper/constants.dart';
import 'package:alumni/services/database.dart';
import 'package:alumni/views/Conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
class ShopBook extends StatefulWidget {
  const ShopBook({Key? key}) : super(key: key);

  @override
  _ShopBookState createState() => _ShopBookState();
}
DatabaseMethods databaseMethods = new DatabaseMethods();
late String email;
late String category;
late int counter;
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

initState() {
  email = Constants.myName;
}
class _ShopBookState extends State<ShopBook> {
  initState() {
    email = Constants.myName;
  }
  @override
  Widget build(BuildContext context) {
    createChatRoomAndStartConversation(String userName) {
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
     return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('URL_Br_Year_Name_Price_Email')
                .where("Email", isNotEqualTo: email)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.data == null) {
                counter = 0;
              } else {
                counter = streamSnapshot.data!.docs.length as int;
              }

              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: counter,
                itemBuilder: (ctx, index) =>  streamSnapshot
                    .data!.docs[index]['Branch']!="Misc."

                    ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 450,
                          child: Card(
                            child: Container(
                              child: Card(
                                shadowColor: Color(0xffb000080),
                                elevation: 80,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  ///Text(streamSnapshot.data!.docs[index]['Email']),
                                  children: [
                                    Stack(
                                      children: [
                                        Ink.image(
                                          image: NetworkImage(
                                            streamSnapshot
                                                .data!.docs[index]['URL'],
                                          ),
                                          height: 240,
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                          bottom: 16,
                                          right: 16,
                                          left: 16,
                                          child: streamSnapshot
                                              .data!.docs[index]
                                          ['Price']!=""?Text(
                                            streamSnapshot
                                                .data!.docs[index]
                                            ['Price'] as String ,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 24,
                                            ),
                                          ):Text( "Negotiable",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 24,
                                            ),),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16)
                                          .copyWith(bottom: 0),
                                      child: Text(
                                        streamSnapshot.data!.docs[index]
                                        ['Name'] as String,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(height: 12,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("Branch - " +
                                          streamSnapshot.data!.docs[index]
                                          ['Branch'],
                                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blue[900]),
                                        ),
                                        Text("Year - " +
                                          streamSnapshot.data!.docs[index]
                                          ['Semester'],
                                          style: TextStyle(fontSize: 16,fontWeight:  FontWeight.bold,color: Colors.blue[900]),
                                        ),
                                      ],

                                    ),
                                    ButtonBar(
                                      alignment: MainAxisAlignment.spaceAround,
                                      children: [

                                        FlatButton(
                                          child: Text('Contact'),
                                          onPressed: () {
                                            createChatRoomAndStartConversation( streamSnapshot.data!.docs[index]
                                            ['Email']);

                                          },
                                        ),
                                      ],
                                    ),
                                    Constants.myName=="vermaabhinav363"?FlatButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        DocumentSnapshot ds = streamSnapshot.data!.docs[index];
                                        FirebaseFirestore.instance
                                            .collection("URL_Br_Year_Name_Price_Email")
                                            .doc(ds.id)
                                            .delete();
                                      },
                                    ):Container(),
                                  ],
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )
                    : Container(),
              );
            },
          ),
        ));
  }
}
