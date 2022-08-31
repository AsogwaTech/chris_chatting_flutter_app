import 'package:flutter/cupertino.dart';
// import 'package:main_chat_portfolio/views/signin.dart';
// import 'package:main_chat_portfolio/views/signup.dart';

import '../views/signin.dart';
import '../views/signup.dart';

class AuthHelper extends StatefulWidget {
  const AuthHelper({Key? key}) : super(key: key);

  @override
  _AuthHelperState createState() => _AuthHelperState();
}

class _AuthHelperState extends State<AuthHelper> {
  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn =!showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return  SignIn(toggleView);
    }
    else{
      return SignUp(toggleView);
    }
  }
}