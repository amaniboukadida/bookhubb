import 'dart:async';
import 'package:bookhub/Services/database.dart';
import 'package:bookhub/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class ContactOwner extends StatefulWidget {
  String ownerUid;
  String userUid;
  ContactOwner({this.ownerUid,this.userUid});
  @override
  _ContactOwnerState createState() => _ContactOwnerState();
}

class _ContactOwnerState extends State<ContactOwner> {
  bool ownerDataRetrieved = false;
  bool messagesRetrieved = false;
  String ownerUserName = "";
  String ownerEmailAddress ="";
  String ownerLocation = "";
  String ownerImageUrl ;
  String username = "";
  String convID;
  String lastMsgId;
  final CollectionReference messagesCollection = DataBaseService().msgCollection;
  final CollectionReference conversationsCollection = DataBaseService().conversationCollection;
  bool conversationInitiated = false;
  final listViewController = ScrollController();
  final textFormFieldController = TextEditingController();
  List<Message> messages=[];
  List<DocumentSnapshot > sentDocSnapshot=[];
  List<String> messagesIds=[];
  List<DocumentSnapshot > recievedDocSnapshot=[];
  String message;
  Timer timer;
  int index=0;
  Widget buildMessageWidget(Message msg){
    
    if(msg.senderUid == widget.userUid)
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 200,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height : 3),
            Container(
              padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Text(msg.data,style: TextStyle(color: Colors.white,fontSize: 15),),
            ),
          ],
          ),
        ),
        SizedBox(width : 10)
      ],
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width : 10),
        Container(
          width: 200,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height : 3),
            Container(
              padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15)
              ),
              child: Text(msg.data,style: TextStyle(color: Colors.black,fontSize: 15),),
            ),
          ],
          ),
        ),
      ],
    );
  }
  void addmessages()async {
    bool newmsg = false;
    await messagesCollection
      .where("senderUid",isEqualTo: widget.ownerUid)
      .where("recieverUid",isEqualTo: widget.userUid)
      .get().then((value){
        value.docs.forEach((element) {
          if(!messagesIds.contains(element.id)){
            newmsg=true;
            messagesIds.add(element.id);
            recievedDocSnapshot.add(element);
            messages.add(Message(
              data: element.get("data"),
              dateTime: DateTime.parse( element.get("date")),
              senderUid: element.get("senderUid"),
              recieverUid: element.get("recieverUid"),
              msgId: element.id
            ));
          }
        });
    });
    messages.sort((a, b)=>a.dateTime.compareTo(b.dateTime));
    setState(() {
      if(newmsg)listViewController.jumpTo(listViewController.position.maxScrollExtent+50);
    });
  }
  @override
  void initState(){
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t){ 
      addmessages(); 
    });
    messagesCollection
    .where("senderUid",isEqualTo: widget.userUid)
    .where("recieverUid",isEqualTo: widget.ownerUid)
    .get()
    .then((value)
    {
      sentDocSnapshot.addAll(value.docs);
      messagesCollection
      .where("senderUid",isEqualTo: widget.ownerUid)
      .where("recieverUid",isEqualTo:widget.userUid)
      .get()
      .then((value)
      {
        recievedDocSnapshot.addAll(value.docs);
        sentDocSnapshot.forEach((element) {
        messages.add(
          Message(
            data: element.get("data"),
            dateTime: DateTime.parse(element.get("date")),
            senderUid: element.get("senderUid"),
            recieverUid: element.get("recieverUid"),
            msgId: element.id
          ));
        });
        recievedDocSnapshot.forEach((element) {
        messagesIds.add(element.id);
        messages.add(
          Message(
            data: element.get("data"),
            dateTime: DateTime.parse(element.get("date")),
            senderUid: element.get("senderUid"),
            recieverUid: element.get("recieverUid"),
            msgId: element.id
          ));
        });
        setState(() {
          messages.sort((a, b)=>a.dateTime.compareTo(b.dateTime));
          messagesRetrieved = true;
          listViewController.jumpTo(listViewController.position.maxScrollExtent);
        });
      });
    });
    conversationsCollection
    .where("conversationId",whereIn: [widget.userUid+widget.ownerUid,widget.ownerUid+widget.userUid])
    .get().then((value){
      if(value.docs.isEmpty){
        conversationInitiated = false;
      }else{
        conversationInitiated = true;
        convID = value.docs.last.id;
      }
    });
    DataBaseService().userCollection.doc(widget.ownerUid).get().then(
      (value){
      setState(() {
        ownerUserName = value.get("username");
        ownerEmailAddress = value.get("email");
        ownerLocation = value.get("location");
        ownerImageUrl = value.get("imageProfileUrl");
      });
    });
  }
  @override
  Widget build(BuildContext context) { 
    if(messages.isNotEmpty){
      if(lastMsgId != messages.last.msgId){
        lastMsgId = messages.last.msgId;
        DataBaseService().conversationCollection.doc(convID).update(({"lastMsgId":lastMsgId}));
      }
    }
    //DataBaseService().conversationCollection.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(ownerUserName),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top-MediaQuery.of(context).viewInsets.bottom,
            child: ListView(
              controller: listViewController,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children : [ 
                    Container(
                      height: 150,
                      decoration : BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.indigo[500], Colors.white],
                        )
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height : 10),
                        Stack(
                          children :[
                            Row(
                              children: [
                                SizedBox(width : 5),
                                Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.indigo,
                                      radius: 57,
                                      child: ownerImageUrl==""?
                                      CircleAvatar(
                                        backgroundColor : Colors.indigo[400],
                                        radius: 55,
                                        child: Text(
                                          ownerUserName[0].toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontFamily: "Times New Roman",
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ): ownerImageUrl==null? 
                                      CircleAvatar(
                                        backgroundColor: Colors.indigo,
                                        child: SpinKitThreeBounce(size: 40,color: Colors.white ,),
                                        radius: 55,
                                      ):
                                      CircleAvatar(
                                        radius: 55,
                                        backgroundImage : NetworkImage(ownerImageUrl)
                                      )
                                    ),
                                  ],
                                ),
                                SizedBox(width : 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ownerUserName,
                                      style: TextStyle(
                                        color: Colors.indigo[800],
                                        fontSize: 20,fontFamily: "Times New Roman",fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height : 5),
                                    Text(
                                      ownerEmailAddress,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,fontFamily: "Times New Roman"
                                      ),
                                    ),
                                    SizedBox(height : 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children :[
                                        Icon(
                                          Icons.location_pin,
                                          color: Colors.indigo,
                                        ),
                                        Text(
                                          ownerLocation,
                                          style: TextStyle(color: Colors.black87,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width:4)
                                      ]
                                    ),
                                ],)
                              ],
                            ),
                          ]
                        ),
                       
                      ],
                    ),
                  ]
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: 
                  messages.map((e) {
                    return buildMessageWidget(e);}).toList()
                ,),SizedBox(height: 90,),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
              //height: 50,
              width: MediaQuery.of(context).size.width,
              color: Colors.indigo[200],
              child : Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(25, 5, 5, 5),
                      child: TextFormField(
                        controller: textFormFieldController,
                        textAlignVertical: TextAlignVertical.center,
                        
                        onChanged: (val){ 
                          message = val.toString();
                        },
                        onTap: (){ listViewController.jumpTo(listViewController.position.maxScrollExtent); },
                        obscureText: false,
                        minLines : 1,
                        maxLines : 2,
                        decoration: InputDecoration(
                          hintText: "Aa",
                          filled: true,
                          fillColor: Colors.white60,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Colors.white70,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: (){
                        if(message!=null){
                          setState((){
                            DataBaseService()
                            .updateMessagesData(senderUid:widget.userUid,recieverUid:widget.ownerUid,date :DateTime.now().toString(),data : message)
                            .then((value){lastMsgId = value.id;})
                            .then((value){
                              messages.add(
                                Message(
                                  data: message,
                                  dateTime: DateTime.now(),
                                  senderUid: widget.userUid,
                                  recieverUid: widget.ownerUid,
                                  msgId : lastMsgId
                                )
                              );
                              if(!conversationInitiated){
                                DataBaseService().updateConversationsData(
                                  conversationId: widget.userUid+widget.ownerUid,
                                  user1id: widget.userUid,
                                  user2id: widget.ownerUid,
                                  lastMsgId: lastMsgId
                                )
                                .then((value) {
                                  convID = value.id;
                                  conversationInitiated = true;
                                });
                              }
                              //update the screen and scroll to last msg
                              textFormFieldController.clear();
                              if(listViewController.position.maxScrollExtent!=0){ 
                                listViewController.jumpTo(listViewController.position.maxScrollExtent+50);
                              }
                              lastMsgId = null;
                              message = null;
                            });
                          });
                        }
                      },
                      child: Icon(Icons.send,color: Colors.indigo,),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}