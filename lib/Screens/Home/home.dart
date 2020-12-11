import 'package:bookhub/Screens/Home/userprofile.dart';
import 'package:bookhub/Services/Auth.dart';
import 'package:bookhub/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:bookhub/Services/database.dart";
import "package:provider/provider.dart";

class Home extends StatefulWidget {
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  bool userprofileOn = false;
  bool searchBarOn = false;
  List test = [5,5,5,5,5,5,5,5];
  @override
  Widget build(BuildContext context) {
    return Provider<CollectionReference>.value(
      value: DataBaseService().userCollection,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BookHub'),
          actions: [
            !userprofileOn? FlatButton.icon(
              onPressed: () async{
                setState(() {
                   userprofileOn = true;
                });
                //await _auth.signOut();
              }, 
              icon: Icon(
                Icons.person, 
                color: Colors.white,
              ), 
              label: Text(
                "Profile",style: TextStyle(
                  color: Colors.white 
                ) ,
              )
            ):FlatButton.icon(
              onPressed: () async{
                setState(() {
                   userprofileOn = false;
                });
                //await _auth.signOut();
              }, 
              icon: Icon(
                Icons.home, 
                color: Colors.white,
              ), 
              label: Text(
                "Home",style: TextStyle(
                  color: Colors.white 
                ) ,
              )
            ),
          ],
        ),
        body: userprofileOn? UserProfile(auth : _auth): Column(children: [
          Stack(
            children: [
              Container(
                height : MediaQuery.of(context).size.height-(MediaQuery.of(context).padding.top + kToolbarHeight),
                child: ListView(
                  children: [
                    SizedBox(height : 70),
                    Column(
                      children: 
                        test.map((e) => Column(children: [SizedBox(height : 10) ,Container(height: 150,color: Colors.indigo[50],)],) ).toList()
                      
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 70,
                        color: Colors.lightBlue[400],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15,12,5,10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Container(
                            height: 50,
                            child: TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                ),
                                hintText : "Search on BookHub",
                                hintStyle: TextStyle(),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue[600],
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Stack(
                            alignment: Alignment.center,
                            children : [
                              Material(
                                shape : CircleBorder(),
                                clipBehavior : Clip.hardEdge,
                                child : Container(
                                  color: Colors.blue[600],
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              Material(
                                shape : CircleBorder(),
                                clipBehavior : Clip.hardEdge,
                                child : Container(
                                  width: 46,
                                  height: 46,
                                  child : InkWell(
                                    onTap  : () {},
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Icon(Icons.search,color: Colors.blue[600],size: 40,),
                                    ) 
                                  ),
                                ),
                              ),
                            ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]
          ),
        ],)
      ),
    );
  }
}