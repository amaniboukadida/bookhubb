import 'package:bookhub/Screens/ContactOwner.dart';
import 'package:bookhub/Services/database.dart';
import 'package:bookhub/models/message.dart';
import 'package:bookhub/models/user.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/models/Conversation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  UserModel user;
  ChatScreen({this.user});
  bool convUpdated = false;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Conversation>conversations=[];
  final DateFormat formatter = DateFormat('M/d-H:m');

  Future getConversationData(Conversation conversation)async{
    await DataBaseService().userCollection.doc(conversation.user2Id).get().then((value){
      conversation.user2imageUrl = value.get("imageProfileUrl");
      conversation.user2userName = value.get("username");
    });
    await DataBaseService().msgCollection.doc(conversation.lastMsgId).get().then((value){
      conversation.lastMsg = Message(
        dateTime: DateTime.parse(value.get("date")),
        recieverUid : value.get("recieverUid"),
        senderUid :value.get("senderUid"),
        data: value.get("data"),
      );
      if(conversation.lastMsg.senderUid==conversation.userId){
        conversation.lastMsg.data = "You : "+conversation.lastMsg.data;
      }else{
        conversation.lastMsg.data = conversation.user2userName.split(" ").first+" : "+conversation.lastMsg.data;
      }
    });
    return "done";
  }
  Widget buildConversation(Conversation conversation){
    return FutureBuilder(
      future: getConversationData(conversation),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
              builder:(_)=>ContactOwner(ownerUid : conversation.user2Id,userUid : conversation.userId))).then((value){
                setState(() {
                  print("object");
                });
              });
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(children: [
                      CircleAvatar(
                        backgroundImage : NetworkImage(conversation.user2imageUrl),
                        radius: 35,
                      )
                    ],),
                    SizedBox(width : 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(conversation.user2userName,style: TextStyle(fontSize: 19,backgroundColor: Colors.transparent),),
                        Row(
                          children: [
                            Container(child: Text(conversation.lastMsg.data.length>18?conversation.lastMsg.data.substring(0,18)+"...":conversation.lastMsg.data, style: TextStyle(fontSize: 16),)),
                            SizedBox(width:10),
                            Text(formatter.format(conversation.lastMsg.dateTime))
                          ],
                        )
                      ],
                    ),
                  ]
                ),
              )
            ),
          );
        }else{
          return Container(
            height: 70,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0), 
            child : SpinKitRipple(color: Colors.white,size: 50,)
          );
        }
      },
    );
  }
  Future getConversations() async
  {
    await DataBaseService().conversationCollection
    .where("user1Id",isEqualTo: widget.user.uid)
    .get().then((value){
      value.docs.forEach((element) {
        conversations.add(Conversation(userId: widget.user.uid,user2Id :element.get("user2Id"),lastMsgId :element.get("lastMsgId")));
      });
    });
    await DataBaseService().conversationCollection
    .where("user2Id",isEqualTo: widget.user.uid)
    .get().then((value){
      value.docs.forEach((element) {
        conversations.add(Conversation(userId: widget.user.uid,user2Id :element.get("user1Id"),lastMsgId :element.get("lastMsgId"),));
      });
    });
    return "done";
  }
  void initState(){
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    //conversations.sort((a, b)=>a.lastMsg.dateTime.compareTo(b.lastMsg.dateTime));
    conversations = [];
    return FutureBuilder(
      future: getConversations(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          return ListView(
            children: conversations.map((e) => buildConversation(e)).toList()
          );
        }else{
          return SpinKitCircle(color: Colors.white,);
        }
      }
    );
  }
}