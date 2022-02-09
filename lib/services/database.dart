import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  getUserByUserName(String username) async {
     return await FirebaseFirestore.instance.collection("Users").where("name", isEqualTo: username).get();
  }
  getUserByEmail(String email) async {
    return await FirebaseFirestore.instance.collection("Users").where("email", isEqualTo: email).get();
  }
  getWetherExistByEmail(String email) async {
    return await FirebaseFirestore.instance.collection("Users").where("email", isEqualTo: email).snapshots();
  }
  uploadUserInfo(userMap) async {
    FirebaseFirestore.instance.collection("Users").add(userMap);
  }
  createChatRoom(String chatRoomId , chatRoomMap){
      FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e){
        print(e.toString());
      });
  }
  updateChatRoomTrue(String chatRoomId , String myName){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).update({
      myName : true,
    }).catchError((e){
      print(e.toString());
    });
  }
  updateChatRoomFalse(String chatRoomId , String myName){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).update({
      myName : false,
    }).catchError((e){
      print(e.toString());
    });
  }
  addConversationMessages(String chatRoomId,messageMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection('Chats').add(
      messageMap
    );
  }
  getConversationMessages (String chatRoomId) async {
   return await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection('Chats').snapshots();
  }
  getChatRoom(String UserName) async{
    return await FirebaseFirestore.instance.collection("ChatRoom").where("users",arrayContains: UserName).snapshots();
  }
  getMyCourse(String UserName) async{
    return await FirebaseFirestore.instance.collection("Courses").where("user",isEqualTo: UserName).snapshots();
  }
  getAllCourse(String UserName) async{
    return await FirebaseFirestore.instance.collection("Courses").where("user",isNotEqualTo: UserName).snapshots();
  }

}