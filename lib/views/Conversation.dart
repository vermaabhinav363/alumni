import 'dart:async';
import 'package:alumni/helper/constants.dart';
import 'package:alumni/services/database.dart';
import 'package:alumni/views/SearchOrAddItems.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  String chatRoomId;

  Conversation(this.chatRoomId);

  @override
  _ConversationState createState() => _ConversationState();
}
late Stream <QuerySnapshot> stream;
DatabaseMethods databaseMethods = new DatabaseMethods();
TextEditingController SendMessage = new TextEditingController();
class _ConversationState extends State<Conversation> {
  Widget ChatMessageList() {
    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot snapshot) {
          print("testing");
          return snapshot.hasData ?ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(snapshot.data!.docs[index]["Message"],snapshot.data!.docs[index]["sendBy"] );
              }): Container();
        });
  }

  sendMessage() {
    Map<String, dynamic> messageMap = {
      "Message": SendMessage.text,
      "sendBy": Constants.myName,
      "time" : DateTime.now().microsecondsSinceEpoch
    };
     String userName = widget.chatRoomId.replaceAll("_", "").replaceAll(Constants.myName, "");
    Map<String,bool> userBooleanMap = {
      userName:true,
      Constants.myName:false
    };
    Map<String, dynamic> chatRoomMap = {
      "chatroomId": widget.chatRoomId,
      "users":  [userName, Constants.myName],

    };

    databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    databaseMethods.updateChatRoomFalse(widget.chatRoomId, userName);
    databaseMethods.updateChatRoomTrue(widget.chatRoomId, Constants.myName);

  }

  @override
  void initState() {
    stream  = FirebaseFirestore.instance.collection("ChatRoom").doc(widget.chatRoomId).collection('Chats').orderBy("time",descending: false).snapshots();
    String userName = widget.chatRoomId.replaceAll("_", "").replaceAll(Constants.myName, "");

    databaseMethods.updateChatRoomFalse(widget.chatRoomId, userName);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        String userName = widget.chatRoomId.replaceAll("_", "").replaceAll(Constants.myName, "");

        databaseMethods.updateChatRoomFalse(widget.chatRoomId, userName);
        //trigger leaving and use own data
        Navigator.pop(context, false);
        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffb000080),
          elevation: 0,
          title:Text(widget.chatRoomId.replaceAll("_", "").replaceAll(Constants.myName, ""))
        ),
        body: Container(
          child: Stack(
            children: [
              Container(alignment: Alignment.topCenter,height: MediaQuery.of(context).size.height -200,child: ChatMessageList()),
              
              Container(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(

                    height: 80,
                    color: Colors.grey[400],
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                            hintText: "Send Message . . .",
                            border: InputBorder.none,
                          ),
                          controller: SendMessage,
                        )),
                        IconButton(
                          color: Color(0xffb000080),
                          onPressed: () {
                            if (SendMessage.text.isNotEmpty) {
                              sendMessage();
                              SendMessage.text = "";
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  String Message;
  String sender;
  bool sendByMe=false;
  MessageTile(this.Message,this.sender){
    if(sender== Constants.myName){
      sendByMe = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: sendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(
              top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
                colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
                ]
                : [
                const Color(0xff007EF4),
            const Color(0xff2A75BC)
            ],
          )
      ),
      child: Text(Message,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'OverpassRegular',
              fontWeight: FontWeight.w300)),
    ),
    );
  }
}
