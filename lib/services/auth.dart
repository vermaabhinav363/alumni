import 'dart:async';
import 'package:alumni/module/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
      final FirebaseAuth _auth = FirebaseAuth.instance;
      USER? _userFromFirebaseUser(User user){
        return  USER(user.uid);
      }
      Future signInWithEmail(String email, String password) async {
          try{
            UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
            User? firebaseUser = result.user;
            return _userFromFirebaseUser(firebaseUser!);

          }
          catch(e){
              print(e.toString());
          }
      }
      Future<User?> CreateUserWithEmail(String email, String password) async {
        try{
          UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
          User? firebaseUser = result.user;
          return firebaseUser;

        }
        catch(e){
          print(e.toString());
        }
      }
      Future signUpWithEnailandPassword(String email, String password) async {
            try{
            UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
            User? firebaseUser = result.user;
            return (_userFromFirebaseUser(firebaseUser!));
            }
            catch(e){
              print(e.toString());
            }
      }
      Future resetPassword(String email) async{
            try{
              return await _auth.sendPasswordResetEmail(email: email);
            }
            catch(e){
              print(e.toString());
            }
      }
      Future signOut()async{
            try{
              return await _auth.signOut();
            }
            catch(e){
              print(e.toString());
            }
      }

}