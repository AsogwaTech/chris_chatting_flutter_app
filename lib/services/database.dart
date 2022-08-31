import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserByUserName(String userName) async{
   return await FirebaseFirestore.instance.collection('userinfos').where('name', isEqualTo: userName).get()
   .catchError((e){
     print(e);
   });//for searching the user via name
  }


  getUserByUserEmail(String userEmail) async{
    return await FirebaseFirestore.instance.collection('userinfos').where('email', isEqualTo: userEmail).get()
        .catchError((e){
      print(e);
    });//for searching the user via name
  }

  // This function will be responsible for collection of the user info at the sign up page and uploading it to our database
  //the user info is a key value pair and it will be converted to map at the point of calling the function
  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection('userinfos').add(userMap).catchError((e){
      print(e);
    });
  }

  //here the id is set manually using the chatroom id.
  createChatRoom(String chatRoomId,chatRoomMap){
    FirebaseFirestore.instance.collection('ChatRoom').doc(chatRoomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  // the function responsible for the chat messages
  //we only use doc when we use manually generated id

addConversationMessages(String chatRoomId,userMessageMap){
    FirebaseFirestore.instance.collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(userMessageMap).catchError((e){print(e.toString());});
}

getConversationMessages(String chatRoomId)async{
   return await FirebaseFirestore.instance.collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
   .orderBy('timeStamp', descending: false)
        .snapshots();// all the available chat messages
}

//the function that will get the chats in which we are member

getChatBelong(String userName)async{
    return await FirebaseFirestore.instance.collection('ChatRoom')
        .where('userinfos', arrayContains: userName)
        .snapshots();
}

}