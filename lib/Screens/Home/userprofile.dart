import 'package:bookhub/Screens/Home/EditProfile.dart';
import 'package:bookhub/Services/Auth.dart';
import 'package:bookhub/Services/database.dart';
import 'package:bookhub/models/user.dart';
import 'package:bookhub/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  @override
  final AuthService auth;
  String username =" ";
  String email = "";
  String location = "";
  bool userDataRetrieved = false;
  bool editProfileOn = false;
  bool loading = false;
  UserProfile({this.auth});
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Future<List<Widget>> buildBooks(String uid) async{
    List<Widget> test = await DataBaseService().bookCollection.where("user_uid",isEqualTo: uid).get().then((value)
    {
      print(value.docs.length);
      List<Widget> test=[];
      String author;
      String title;
      String category;
      String location;
      for (var doc in value.docs) {
        author = doc.get("author");
        title = doc.get("title");
        category = doc.get("genre");
        location = doc.get("location");
        test.add(Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10,0,0,0),
            child: Container(
              padding: EdgeInsets.all(10),
              height: 110,
              width: 230,
              color: Colors.blue[100],
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 100,
                    child : Image(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/addBook.jpg"),
                    )
                  ),
                  SizedBox(width : 10),
                  Container(
                    width: 140,
                    child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row(children: [
                        Text("Ttile : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(title.length>12?title.substring(0,12)+"...":title)
                      ],),
                      Row(children: [
                        Text("Author : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(author.length>9?author.substring(0,9)+"...":author)
                      ],),
                      Row(children: [
                        Text("category : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(category.length>8?category.substring(0,8)+"...":category)
                      ],),
                      Row(children: [
                        Text("Nbr of pages : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text((doc.get("pageNumbers").toString()))
                      ],),
                      Row(children: [
                        Text("Location : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(location.length>10?location.substring(0,10)+"...":location)
                      ],)
                    ],),
                  ),
                ],
              ),
            ),
          ),
        ));
      }
      return test;
    });
    return test;
  }
  Widget build(BuildContext context) {
    final user = Provider.of<User_>(context);
    final users = Provider.of<CollectionReference>(context);
    if(!widget.userDataRetrieved)users.doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          widget.username = documentSnapshot.get("username");
          widget.email = documentSnapshot.get("email");
          widget.location = documentSnapshot.get("location");
          widget.userDataRetrieved = true;
        });
      } else {
        print('Document does not exist on the database');
      }
    });
    /*for(var doc in users.docs){
      print(doc.id);
    }*/
    return ListView(
      children: [
        Column(
          crossAxisAlignment : CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children : [ 
                Image.asset("assets/userProfile.jpg"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height : 20),
                    Stack(
                      children :[
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 83,
                          child: CircleAvatar(
                            backgroundColor: Colors.lightBlue[300],
                            child: Text(widget.username[0].toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 60,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),),
                            radius: 80,
                          ),
                        ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: Material(
                            color: Colors.transparent,
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: CircleBorder(),
                              ),
                              child : IconButton(
                                iconSize: 25,
                                icon: Icon(Icons.add_a_photo_rounded,color: Colors.white,),
                                color: Colors.black,
                                onPressed: (){}
                              ),
                            ),
                          ),
                        )
                      ]
                    ),
                    SizedBox(height : 10),
                    Text(
                      widget.username,
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 25,fontFamily: "Times New Roman",fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height : 5),
                    Text(
                      widget.email,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,fontFamily: "Times New Roman"
                      ),
                    ),
                    SizedBox(height : 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children :[
                        Icon(
                          Icons.location_pin,
                          color: Colors.blue,
                        ),
                        Text(
                          widget.location,
                          style: TextStyle(color: Colors.black87,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width:4)
                      ]
                    ),
                  ],
                ),
              ]
            ),
            SizedBox(
              height : 15
            ),
            Stack(
              children : [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,0,10,0),
                  child: Column(
                    children: [
                      SizedBox(height : 15),
                      Container(
                        color: Colors.lightBlue[50],
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        child : FutureBuilder(
                          future: buildBooks(user.uid),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if(snapshot.hasData){
                              return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: snapshot.data));
                            }else{
                              return Container(child : SpinKitRipple(color: Colors.blue[100],size: 80,));
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "My Books",
                    style :TextStyle(color: Colors.blue[800],fontSize : 18,fontFamily: "Times New Roman",fontWeight: FontWeight.bold)
                  ),
                ),
              ]
            ),
            SizedBox(
              height : 15
            ),
            Stack(
              children : [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,0,10,0),
                  child: Column(
                    children: [
                      SizedBox(height : 15),
                      Container(
                        color: Colors.lightBlue[50],
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        child : Column(
                          children: [
                            
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "My Offers",
                    style :TextStyle(color: Colors.blue[800],fontSize : 18,fontFamily: "Times New Roman",fontWeight: FontWeight.bold)
                  ),
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  color: Colors.blue,
                  child: Text(
                    "Edit profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                    builder:(_)=>EditProfile(users: users, user: user,)
                    ));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text(
                      "Sign out",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: (){
                      widget.auth.signOut();
                    },
                  ),
                  
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}