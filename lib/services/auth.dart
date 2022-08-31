
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:main_chat_portfolio/model/model.dart';

import '../model/model.dart';

class Authenticate{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFromFirebaseUser(User user){
    return user != null ? AppUser(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password)async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = userCredential.user;
      return _userFromFirebaseUser(firebaseUser!);
    }
    catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = userCredential.user;
      return _userFromFirebaseUser(firebaseUser!);
    }
    catch(e){
      print(e.toString());
    }
  }
  Future resetPassword(String email)async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      print(e.toString());
    }
  }
  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
    }
  }
}