
import 'package:chat/helper/oftenUsedConstants.dart';
import 'package:chat/reusable_widgets/inputDecoration.dart';
import 'package:chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
   const ConversationScreen(this.chatRoomId);

 final  String? chatRoomId;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  TextEditingController chatMessageController = TextEditingController();

  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream<QuerySnapshot>? chatMessageStream;// which is a function of the database methods

  // using stream for real time messaging

 //QuerySnapshot? streamSnapshot;

  Widget chatMessagesList(){
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
            itemBuilder: (context,index){
            return MessageTile(message : snapshot.data?.docs[index]['message'] ??'', sendByMe: snapshot.data?.docs[index]['sendBy'] == Constants.myName);
            }
        );
      },
    );
  }



  sendMessages(){
    if(chatMessageController.text.isNotEmpty){
      Map<String, dynamic> userMessageMap = {
        'message' : chatMessageController.text,
        'sendBy' : Constants.myName,
        'timeStamp' : DateTime.now().microsecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId!,userMessageMap);
    }
    chatMessageController.clear();

  }


  @override
  void initState(){
    databaseMethods.getConversationMessages(widget.chatRoomId!).then((value){
      //print('${value}ok iam hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
      if(value != null){
        setState((){
          chatMessageStream = value;
        });
      }
    });
    super.initState();
  }


  // getMessageStream()async{
  //   await databaseMethods.getConversationMessages(widget.chatRoomId!).then((value){
  //     print('${value}okiam hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
  //     if(value != null){
  //       setState((){
  //         chatMessageStream = value;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Stack(
          children: [
            chatMessagesList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow:const [
                    BoxShadow(
                      offset: Offset(1, 1),
                      color: Colors.white,
                      blurRadius: 0,
                    ),
                  ],
                ),
                // color: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Row(
                  children: [
                     Expanded(// to use the available space
                        child: TextField(
                         controller: chatMessageController,
                          style: const TextStyle(color: Colors.white54),
                          decoration: const InputDecoration(
                            hintText: 'Tye your Message ...',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                        )
                    ),
                    GestureDetector(
                        onTap: (){
                          sendMessages();
                        },
                        child: const Icon(Icons.send_rounded, size: 30,)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({Key? key, required this.message, required this.sendByMe}) : super(key: key);
  final String message;
  final bool sendByMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: sendByMe ? 0 : 8, right: sendByMe ? 8 : 0),
      margin: const EdgeInsets.symmetric(vertical: 8),

        width: MediaQuery.of(context).size.width * 0.5,
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: sendByMe ? Colors.green : Colors.grey.withOpacity(0.5),
          borderRadius: sendByMe ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          ) : const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20)
          )
        ),
        child: Text(message, style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),),
      ),
    );
  }
}
