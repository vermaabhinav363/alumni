import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  getUserByUserName(String username) async {
     return await FirebaseFirestore.instance.collection("Users").where("name", isEqualTo: username).get();
  }
  uploadUserInfo(userMap) async {
    FirebaseFirestore.instance.collection("Users").add(userMap);
  }
  createChatRoom(String chatRoomId , chatRoomMap){
      FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e){
        print(e.toString());
      });
  }
}