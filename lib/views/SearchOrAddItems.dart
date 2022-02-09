
import 'dart:math';
import 'package:alumni/helper/Helperfunction.dart';
import 'package:alumni/helper/constants.dart';
import 'package:alumni/services/auth.dart';
import 'package:alumni/services/database.dart';
import 'package:alumni/views/AddItem.dart';
import 'package:alumni/views/Conversation.dart';
import 'package:alumni/views/Intro.dart';
import 'package:alumni/views/MyAd.dart';
import 'package:alumni/views/SearchCourse.dart';
import 'package:alumni/views/SetCourse.dart';
import 'package:alumni/views/Shop.dart';
import 'package:alumni/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
class SearchAdd extends StatefulWidget {
  const SearchAdd({Key? key}) : super(key: key);

  @override
  _SearchAddState createState() => _SearchAddState();
}

int count = 0;
DatabaseMethods databaseMethods = new DatabaseMethods();
AuthMethods authMethods = new AuthMethods();
dynamic searchSnapshot;
late Stream <QuerySnapshot>  chatRoomStream;
Widget chatRoomList(){
  return StreamBuilder(

      stream: chatRoomStream,
      builder: (context,AsyncSnapshot snapshot){
          return snapshot.hasData ?Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context,index){
                    return ChatRoomTile(snapshot.data.docs[index]["chatroomId"].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),snapshot.data.docs[index]["chatroomId"],snapshot.data.docs[index][snapshot.data.docs[index]["chatroomId"].toString().replaceAll("_", "").replaceAll(Constants.myName, "")]);
                }
            ),
          ):Container(

          );
      }
  );
}
TextEditingController searchEditingController = new TextEditingController();

class _SearchAddState extends State<SearchAdd> {
  initiateSearch() {

    databaseMethods.getUserByUserName(searchEditingController.text.toLowerCase().replaceAll(" ", "")).then((val) {
      setState(() {
        searchSnapshot = val;
        count = searchSnapshot.docs.length as int;

        if(searchSnapshot.docs.length==0){
          showAlertDialog(context);
        }

      });
    });
  }

  Widget searchList() {

    return searchSnapshot != null ?ListView.builder(
      itemCount: searchSnapshot.docs.length as int,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return searchSnapshot.docs[index].get('name')!=Constants.myName ?SearchTile(
          userName: searchSnapshot.docs[index].get('name'),
          userEmail: searchSnapshot.docs[index].get('email'),
        ) : Container();
      },
    ):Container();
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    databaseMethods.getChatRoom(Constants.myName).then((val){


      setState(() {
        chatRoomStream = val;
      });


    });
    super.initState();
    print(Constants.myName);
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPreference();
  }

  createChatRoomAndStartConversation(String userName) {
    List<String> users = [userName, Constants.myName];
    String chatRoomId = getChatRoomId(userName, Constants.myName);


    Map<String, dynamic> chatRoomMap = {
      "chatroomId": chatRoomId,
      "users": users,
      userName:false,
      Constants.myName:false

    };

    databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Conversation(chatRoomId)));
  }

  Widget SearchTile({required String userName, required String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(userEmail)
            ],
          ),
          SizedBox(),
          Container(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                child: Icon(Icons.messenger),
                onTap: () {
                  print(Constants.myName);
                  createChatRoomAndStartConversation(userName);
                },
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text(Constants.myName),
        backgroundColor: Color(0xffb000080),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();

              HelperFunction.saveUserLoggedInSharedPreference(false);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => introduct()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: TextField(
                      controller: searchEditingController,
                      decoration: Tex('Search user by SWD Id'))),
              IconButton(
                color: Colors.blue[100],
                onPressed: () {
                  initiateSearch();
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          searchList(),
          chatRoomList()
        ],
      ),
    );
  }
}
class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(

                  ),
                  child: Text(
                    'Buy and Sell @BPHC',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              decoration: BoxDecoration(

                color: Color(0xffbA9A9A9),
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/BPHC.jpg"),
                    fit: BoxFit.cover ,
                  )
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Host an ad'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddItem()),
                )
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Shop'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Shop()),
                )
              },
            ),
            ListTile(
              leading: Icon(Icons.storage),
              title: Text('See my ads'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAd()),
                )
              },

            ),
            Divider(height: 20,
              thickness: 4,
              indent: 8,
              endIndent: 8,
              color: Color(0xffbA9A9A9)),
            ListTile(
              leading: Icon(Icons.east),
              title: Text('Set course for Swap'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetCourse()),
                )
              },

            ),
            ListTile(
              leading: Icon(Icons.west),
              title: Text('Search course for Swap'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchCourse()),
                )
              },

            ),
          ],
        ),
      ),
    );
  }
}
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
class ChatRoomTile extends StatelessWidget {
  late final String userName;
  late final String chatRoomId;
  late final bool newValue ;
  ChatRoomTile(this.userName,this.chatRoomId, this.newValue);

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>Conversation(chatRoomId)));
      },
      child: Container(
        child: Container(
          color: Colors.grey[200],
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Row(

            children: [
              Container(

                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff),
                  borderRadius:  BorderRadius.circular(40)
                ),
                child:Text(

                   "${userName.substring(0,1)}".toUpperCase(),style: TextStyle(color: Colors.white),
                )
              ),
              SizedBox(width: 8,),
              Flexible(child: Row(

                children: [


                  Text(userName,),
                  Spacer(),
                  newValue?Container(padding : EdgeInsets.all(8), child: Text("New",style: TextStyle(color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff)),)):Text(""),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(

    content: Text("No user found."),
    actions: [],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
