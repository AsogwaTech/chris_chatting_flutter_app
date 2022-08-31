
import 'package:chat/helper/shared_helper.dart';
import 'package:chat/reusable_widgets/inputDecoration.dart';
import 'package:chat/services/database.dart';
import 'package:chat/views/conversation_screen.dart';
import 'package:chat/views/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:main_chat_portfolio/helper/auth_help.dart';
// import 'package:main_chat_portfolio/services/auth.dart';
// import 'package:main_chat_portfolio/views/search.dart';

import '../helper/auth_helper.dart';
import '../helper/oftenUsedConstants.dart';
import '../services/auth.dart';
//import 'package:main_chat_portfolio/views/signin.dart';
//import 'package:main_chat_portfolio/reusable_widgets/inputDecoration.dart';

// This page is for the list of chatting partner instead of searching


class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {

  Authenticate authenticate = Authenticate();

  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream<QuerySnapshot>? chatRoomBelongStream;


 Widget chatRoomBelongList (){
   return StreamBuilder<QuerySnapshot>(
     stream: chatRoomBelongStream,
       builder:(context, snapshot){
       return snapshot.hasData ? ListView.builder(
         itemCount: snapshot.data?.docs.length,
           itemBuilder: (context, index){
           return ChatRoomBelongTile(chatPartnerUserName: snapshot.data!.docs[index]['chatroomid']
           .toString().replaceAll(Constants.myName, '')
               .replaceAll("_", ''),chatRoomId:snapshot.data!.docs[index]['chatroomid'] ,
           );
           }
       ): Container();
       }
   );
 }


  @override
  void initState(){
    getUserInfo(); //to initialize the shared preference when the app is started for the first time
    super.initState();
  }


  getUserInfo() async{
    Constants.myName = (await SharedHelper.getUserNamePreferences())!;
    databaseMethods.getChatBelong(Constants.myName).then((value){
      setState((){
        chatRoomBelongStream = value;
      });
    });
    setState((){

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let Chat'),
        actions: [
          GestureDetector(
            onTap: (){
              authenticate.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const AuthHelper())
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatRoomBelongList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchUser()));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomBelongTile extends StatelessWidget {
  const ChatRoomBelongTile({Key? key, required this.chatPartnerUserName, required this.chatRoomId}) : super(key: key);
  final String chatPartnerUserName;
  final String chatRoomId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId),
        )
        );
      },
      child: Container(
        color: Colors.grey.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        // height: 80,
        // width: 80,
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.blueAccent,
              ),
              child: Text(chatPartnerUserName.substring(0,1).toUpperCase(), style: const TextStyle(color: Colors.white),),
            ),
            const SizedBox(width: 10),
            Text(chatPartnerUserName, style: textStyle(),),
          ],
        ),
      ),
    );
  }
}
