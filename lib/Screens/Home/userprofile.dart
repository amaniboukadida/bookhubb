import 'package:bookhub/Services/Auth.dart';
import 'package:bookhub/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  @override
  final AuthService auth;
  String username =" ";
  String email = "";
  String location = "";
  bool userDataRetrieved = false;
  UserProfile({this.auth});
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
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
                Image.network("https://images.all-free-download.com/images/graphicthumb/embossment_triangular_blue_background_vector_586401.jpg"),
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
                            //backgroundImage: NetworkImage("https://i1.wp.com/caravetclinic.com/wp-content/uploads/2016/07/person-icon-blue.png?fit=387%2C387&ssl=1"),
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
                        height: 160,
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
                        height: 160,
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