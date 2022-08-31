
import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
//import 'package:main_chat_portfolio/reusable_widgets/inputDecoration.dart';

import '../helper/shared_helper.dart';
import '../reusable_widgets/inputDecoration.dart';
import 'chatRoomScreen.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  const SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {


  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  QuerySnapshot? userInfoSnapshot;

  Authenticate authenticate = Authenticate();

  DatabaseMethods databaseMethods = DatabaseMethods();

signUserIn(){
  if(formKey.currentState!.validate()){
    SharedHelper.saveUserEmailPreferences(emailController.text);

    databaseMethods.getUserByUserEmail(emailController.text).then((value){
      userInfoSnapshot= value;
      SharedHelper.saveUserNamePreferences(userInfoSnapshot?.docs[0]['name']);
    });

    setState(() {
      isLoading = true;
    });


    authenticate.signInWithEmailAndPassword(emailController.text, passwordController.text).then((value) {
      if(value != null){
        SharedHelper.saveUserLoggedInPreferences(true);

        Navigator.pushReplacement(context, MaterialPageRoute(
          builder:(context) => const ChatRoomScreen(),
        ));
      }
    }

    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: mainAppBar(context),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: textFieldInputDecoration('Email'),
                      style: textStyle(),
                      validator: (String? value){
                        return EmailValidator.validate(value!) ? null : 'Email is not valid';
                      },
                    ),
                    TextFormField(
                      obscureText:  true,
                      controller: passwordController,
                      decoration: textFieldInputDecoration('Password'),
                      style: textStyle(),
                      validator: (String? value){
                        return value!.isEmpty || value.length < 6 ? 'password should be greater than four characters' : null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Text('Forgot Password?', style: textStyle()),
                ),
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  signUserIn();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.white54
                      ],
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text('Sign In', style: textStyle(),),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Text('Sign In With Google', style: TextStyle(color: Colors.black,fontSize: 17)),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Text('Don\'t have an account?  ', style: TextStyle(color: Colors.white,fontSize: 17),),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text('Register now', style: TextStyle(color: Colors.white,fontSize: 17,decoration: TextDecoration.underline))),
                  ),
                ],
              ),
              const SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}