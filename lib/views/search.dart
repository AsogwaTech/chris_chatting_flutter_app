
import 'dart:ffi';

import 'package:chat/helper/oftenUsedConstants.dart';
import 'package:chat/helper/shared_helper.dart';
import 'package:chat/services/database.dart';
import 'package:chat/views/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:main_chat_portfolio/reusable_widgets/inputDecoration.dart';

import '../reusable_widgets/inputDecoration.dart';
import 'chatRoomScreen.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  _SearchUserState createState() => _SearchUserState();
}


String? _myName;

class _SearchUserState extends State<SearchUser> {

  DatabaseMethods databaseMethods = DatabaseMethods();


  TextEditingController searchUser= TextEditingController();


  QuerySnapshot? searchSnapshot;





  Widget searchUserList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot?.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchListTile(
            username: searchSnapshot?.docs[index]['name'],
            email: searchSnapshot?.docs[index]['email'],
          );
        }
    ) : Container(
      // child: const Center(
      //   child: Text('Enter correct userName',
      //   style: TextStyle(
      //     color: Colors.white,
      //     fontWeight: FontWeight.bold,
      //     fontSize: 20,
      //   ),),
      // ),
    );//not user friendly, try show the user something
  }


  initiateSearchUser(){
    databaseMethods.getUserByUserName(searchUser.text).then((value){
      setState(() {
        searchSnapshot = value;
      });
      //print(value.toString());
    });
  }


 // function to navigate to the chat and conversation screen





  // Widget searchUserList(){
  //   return searchSnapshot != null ? ListView.builder(
  //     itemCount: searchSnapshot?.docs.length,
  //       shrinkWrap: true,
  //       itemBuilder: (context, index){
  //       return SearchListTile(
  //           username: searchSnapshot?.docs[index]['name'],
  //           email: searchSnapshot?.docs[index]['email'],
  //       );
  //       }
  //   ) : Container();
  // }
  //
  //
  // createChatRoomAndStartConverse({ required String userName}){
  //
  //   String chatRoomId = getChatRoomId(userName, Constants.myName);
  //   List<String> users = [userName, Constants.myName];
  //
  //   Map<String, dynamic> chatRoomMap = {
  //     'userinfos' : users,
  //     'chatroomid' : chatRoomId,
  //   };
  //
  //   DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
  //
  //   Navigator.push(context, MaterialPageRoute(
  //     builder:(context) => const ConversationScreen(),
  //   ));
  // }


  createChatRoomAndStartConverse({ required String userName}){

    if (userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];

      Map<String, dynamic> chatRoomMap = {
        'userinfos' : users,
        'chatroomid' : chatRoomId,
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);

      Navigator.push(context, MaterialPageRoute(
        builder:(context) => ConversationScreen(chatRoomId),
        // sending the chatRoomId to the the conversation screen
      ));
    }
    else{
      print('you cannot message yourself');
    }
  }




  Widget SearchListTile({required String username, required String email}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: textStyle(),),
              Text(email, style: textStyle(),),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){

              createChatRoomAndStartConverse(userName: username);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: const Text('Message'),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void initState(){

    // getUserInfo();
    super.initState();
  }


  // getUserInfo() async {
  //   _myName = await SharedHelper.getUserNamePreferences();
  //   setState((){
  //
  //   });
  //   print('${_myName}');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:mainAppBar(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Row(
                children: [
                  Expanded(// to use the available space
                      child: TextField(
                        controller: searchUser,
                        style: const TextStyle(color: Colors.white54),
                        decoration: const InputDecoration(
                          hintText: 'Search AppUser',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearchUser();
                    },
                      child: const Icon(Icons.search, size: 30,)),
                ],
              ),
            ),
            searchUserList(),
          ],
        ),
      ),
    );
  }
}



// class SearchListTile extends StatelessWidget {
//   const SearchListTile({Key? key, required this.username,required this.email}) : super(key: key);
//
//   final  String username;
//   final String email;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(username, style: textStyle(),),
//               Text(email, style: textStyle(),),
//             ],
//           ),
//           const Spacer(),
//           GestureDetector(
//             onTap: (){
//
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
//               child: const Text('Message'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

getChatRoomId(String a,String b){
 if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
   return '$b\_$a';
 } else{
   return '$a\_$b';
 }
}
