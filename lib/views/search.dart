import 'package:alumni/services/database.dart';
import 'package:alumni/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

TextEditingController searchEditingController = new TextEditingController();
DatabaseMethods databaseMethods = new DatabaseMethods();
dynamic searchSnapshot;
//createChatRoomAndSendUser(String userName){
//  List <String > users = [userName , myName];
//  databaseMethods.createChatRoom(chatRoomId, chatRoomMap)
//}
Widget searchList() {
  return searchSnapshot != null
      ? ListView.builder(
          shrinkWrap: true,
          itemCount: searchSnapshot.docs.length,
          itemBuilder: (context, index) {
            return SearchTile(
              userName: searchSnapshot.docs[index].get('name'),
              userEmail: searchSnapshot.docs[index].get('email'),
            );
          })
      : Container(
          child: Text('Debugging Going null'),
        );
}

class _SearchScreenState extends State<SearchScreen> {
  initiateSearch() {
    databaseMethods.getUserByUserName(searchEditingController.text).then((val) {
      print('hello');
      print(val);
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(
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
                          decoration: Tex('Enter User Name'))),
                  IconButton(
                    color: Colors.blue[100],
                    onPressed: () {
                      initiateSearch();
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              searchList()
            ],
          ),
        ));
  }
}

class SearchTile extends StatelessWidget {
  //const SearchTile({Key? key}) : super(key: key);
  final String userName;
  final String userEmail;

  SearchTile({required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [Text(userName), Text(userEmail)],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
                onTap: (){

                },
                child: Text("Message")
            ),
          )
        ],
      ),
    );
  }
}
