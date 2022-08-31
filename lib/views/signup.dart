import 'package:chat/helper/shared_helper.dart';
import 'package:chat/services/database.dart';
import 'package:flutter/material.dart';
//import 'package:main_chat_portfolio/reusable_widgets/inputDecoration.dart';
import 'package:email_validator/email_validator.dart';
//import 'package:main_chat_portfolio/services/auth.dart';

import '../reusable_widgets/inputDecoration.dart';
import '../services/auth.dart';
import 'chatRoomScreen.dart';


class SignUp extends StatefulWidget {
  final Function toggle;
  const SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  Authenticate authenticate = Authenticate();//instantiating the auth class which bears the function of authenticating a user

  DatabaseMethods databaseMethods =DatabaseMethods();

  //SharedHelper sharedHelper = SharedHelper();

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();


  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  signUserUp(){
    if(formKey.currentState!.validate()){
      Map<String,String> userInfoMap = {
        'name' : userNameController.text,
        'email' : emailController.text
      };

      SharedHelper.saveUserNamePreferences(userNameController.text);
      SharedHelper.saveUserEmailPreferences(emailController.text);


      setState(() {
        isLoading = true;
      });
      authenticate.signUpWithEmailAndPassword(emailController.text, passwordController.text).then((value) => print('$value'));

     // print('i am correct up to here and equally here');
      databaseMethods.uploadUserInfo(userInfoMap);
      //print('here is ok with me');
      SharedHelper.saveUserLoggedInPreferences(true);

      Navigator.pushReplacement(context, MaterialPageRoute(
        builder:(context) => const ChatRoomScreen(),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body:isLoading ? Container(
        child: const Center(child:  CircularProgressIndicator()),// we want to call the auth function as it is loading
      ) : Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: userNameController,
                        decoration: textFieldInputDecoration('Username'),
                        style: textStyle(),
                        validator: (String? value){
                          return value!.isEmpty || value.length < 4 ? 'username should be greater than four characters' : null;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: textFieldInputDecoration('Email'),
                        style: textStyle(),
                        validator: (String? value){
                          return EmailValidator.validate(value!) ? null : 'Email is not valid';
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
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
                    signUserUp();
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
                    child: Text('Sign Up', style: textStyle(),),
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
                  child: const Text('Sign Up With Google', style: TextStyle(color: Colors.black,fontSize: 17)),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text('Already have an account?  ', style: TextStyle(color: Colors.white,fontSize: 17),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text('Sign in now', style: TextStyle(color: Colors.white,fontSize: 17,decoration: TextDecoration.underline))),
                    ),
                  ],
                ),
                const SizedBox(height: 70,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}