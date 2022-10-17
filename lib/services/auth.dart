import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:quizmaker/models/user.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UDUser? _userFromFirebaseUser(User user) {
    return UDUser(uid:  user.uid);
  }


  Future signInEmailAndPass(String email, String password) async{
    try{
      UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser!);
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {

    try{
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      return _userFromFirebaseUser(user!);
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }

  }

  Future signOut() async{

    try{
      return await _auth.signOut();
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
}