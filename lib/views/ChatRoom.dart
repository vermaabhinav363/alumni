import 'package:alumni/services/auth.dart';
import 'package:alumni/views/intro.dart';
import 'package:alumni/views/search.dart';
import 'package:flutter/material.dart';
class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}
AuthMethods authMethods = new AuthMethods();
class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => introduct()));

            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: Container(

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        },
        child: Icon(Icons.search),
      ),

    );
  }
}
