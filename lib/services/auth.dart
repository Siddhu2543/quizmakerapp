import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizmaker/models/user.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UDUser? _userFromFirebaseUser(User user) {

    return user != null ? UDUser(uid:  user.uid) : null;
  }


  Future signInEmailAndPass(String email, String password) async{
    try{
      UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser!);
    }catch(e){
      print(e);
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {

    try{
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      return _userFromFirebaseUser(user!);
    }catch(e){
      print(e.toString());
      return null;
    }

  }

  Future signOut() async{

    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}