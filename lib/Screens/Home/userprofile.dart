import 'dart:io';
import "package:firebase_storage/firebase_storage.dart";
import 'package:bookhub/Screens/Home/EditProfile.dart';
import 'package:bookhub/Services/Auth.dart';
import 'package:bookhub/Services/database.dart';
import 'package:bookhub/models/Book.dart';
import 'package:bookhub/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UserProfile extends StatefulWidget {
  final AuthService auth;
  String username =" ";
  String email = "";
  String location = "";
  bool userDataRetrieved = false;
  bool editProfileOn = false;
  bool loading = false;
  UserProfile({this.auth});
  String imageUrl;
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  
  final picker = ImagePicker();
  UploadTask uploadTask;
  File sampleImage;
  Future<List<Widget>> buildBooks(String uid) async{
    List<Widget> test = await DataBaseService().bookCollection.where("user_uid",isEqualTo: uid).get().then((value)
    {
      List<Widget> test=[];
      for (var doc in value.docs) {
        test.add(new Book(
          author: doc.get("author"), 
          title: doc.get("title"), 
          category: doc.get("genre"), 
          location: doc.get("location"),
          docUid: doc.id, 
          ownerUid: doc.get("user_uid"), 
          pageNumber: doc.get("pageNumbers"),
          screenId: 1,)//Profilescreen
        );
      }
      return test;
    });
    return test;
  }
  Future getImage(UserModel user, CollectionReference users) async{
    String fileName = widget.email.replaceAll("@", "-");
    Reference storageRef = FirebaseStorage.instance.ref().child("user-sProfiles").child(fileName);
    // ignore: deprecated_member_use
    var tempImage = await picker.getImage(source: ImageSource.gallery,maxHeight:  400 , maxWidth: 400);
    sampleImage = File(tempImage.path);
    if(sampleImage!=null){
      if(!(widget.imageUrl=="" || widget.imageUrl==null)){
        await storageRef.delete();
        await users.doc((user.uid)).update({"imageProfileUrl":null});
      }
      uploadTask = storageRef.putFile(sampleImage);
      uploadTask.snapshotEvents.listen((event) async {
        if(event.state==TaskState.success){
          widget.imageUrl = await storageRef.getDownloadURL();
          users.doc((user.uid)).update({"imageProfileUrl":widget.imageUrl}).then((value){
            print("done !!!!!");
            setState((){
              user.avatarChild = CircleAvatar(
                backgroundImage: checkURL(widget.imageUrl),
                radius: 80,
              );
              widget.userDataRetrieved = false;
            });
          });
        }else{
          setState((){
            user.avatarChild = CircleAvatar(
              backgroundColor: Colors.blue,
              child: SpinKitThreeBounce(size: 40,color: Colors.white ,),
              radius: 80,
            );
          });
        }
      });
    }
  }

  ImageProvider checkURL(String url)
  {
    try {
      ImageProvider test = NetworkImage(url);
      return test;
    } catch (e) {
      ImageProvider test = AssetImage("assets/userProfile.jpg");
      return test;
    }
  }
     
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final users = Provider.of<CollectionReference>(context);
    widget.userDataRetrieved = false;
    if(!widget.userDataRetrieved)users.doc(user.uid).get().then((DocumentSnapshot documentSnapshot)async {
      if (documentSnapshot.exists) {
        widget.username = await documentSnapshot.get("username");
        widget.email = await documentSnapshot.get("email");
        widget.location = await documentSnapshot.get("location");
        widget.imageUrl = await documentSnapshot.get("imageProfileUrl");
        setState(() {
          widget.userDataRetrieved = true;
        });
      } else {
        print('Document does not exist on the database');
      }
    });
    if(!(widget.imageUrl=="" || widget.imageUrl == null)){
      user.avatarChild = CircleAvatar(
        backgroundImage: checkURL(widget.imageUrl),
        radius: 80,
      );
    }
    /*for(var doc in users.docs){
      print(doc.id);
    }*/
    return 
    ListView(
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
                          child: user.avatarChild==null?CircleAvatar(
                            backgroundColor : Colors.blue[400],
                            radius: 80,
                            child: Text(
                              widget.username[0].toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontFamily: "Times New Roman",
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ): user.avatarChild
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
                                onPressed: () async{
                                  await getImage(user, users);
                                }
                              )
                            ),
                          ), 
                        ),
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