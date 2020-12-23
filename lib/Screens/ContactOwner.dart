import 'package:bookhub/Services/database.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class ContactOwner extends StatefulWidget {
  String ownerUid;
  ContactOwner({this.ownerUid});
  @override
  _ContactOwnerState createState() => _ContactOwnerState();
}

class _ContactOwnerState extends State<ContactOwner> {
  bool ownerDataRetrieved = false;
  String ownerUserName = "";
  String ownerEmailAddress ="";
  String ownerLocation = "";
  String ownerImageUrl ;
  String username = "";
  List<String> test=["test 123!","cblablalbalbaln","chy chy ena ncody wena fel reunion","barcha waste of time","so 7abit nra how messenger starts a conversation"];

  @override
  Widget build(BuildContext context) {
    if(!ownerDataRetrieved)
    {
       DataBaseService().userCollection.doc(widget.ownerUid).get().then(
      (value){
        ownerUserName = value.get("username");
        ownerEmailAddress = value.get("email");
        ownerLocation = value.get("location");
        ownerImageUrl = value.get("imageProfileUrl");
        setState(() {
          ownerDataRetrieved = true;
        });
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(ownerUserName),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height-AppBar().preferredSize.height-50-MediaQuery.of(context).padding.top,
            child: ListView(
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
                  test.map((e) {
                    double k = double.parse(e.length.toString())*6;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                        children: [
                          SizedBox(height : 5),
                          Container(
                            width: k>=250?250:k,
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(e,style: TextStyle(color: Colors.white,fontSize: 15),),
                          ),
                        ],
                        ),
                        SizedBox(width : 10)
                      ],
                    );}).toList()
                ,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: 
                  test.map((e) {
                    double k = double.parse(e.length.toString())*6;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        SizedBox(width : 10),
                        Column(
                        children: [
                          SizedBox(height : 5),
                          Container(
                            width: k>=250?250:k,
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(e,style: TextStyle(color: Colors.black,fontSize: 15),),
                          ),
                        ],
                        ),
                      ],
                    );}).toList()
                ,) 
              ],
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: Colors.indigo[200],
            child : Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25, 5, 5, 5),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      validator: (val){
                        return val.length<5? "Username must be 5+ characters" : null;
                      },
                      initialValue: "Aa",
                      onChanged: (val){

                      },
                      obscureText: false,
                      decoration: InputDecoration(
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
                Expanded(flex: 2,child: Icon(Icons.send,color: Colors.indigo,))
              ],
            ),
          )
        ],
      ),
    );
  }
}