import 'dart:async';
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

// ignore: must_be_immutable
class UserProfile extends StatefulWidget {
  static bool bookdeleted;
  final AuthService auth;
  UserModel user;
  String username =" ";
  String email = "";
  String location = "";
  bool userDataRetrieved = false;
  bool editProfileOn = false;
  bool loading = false;
  UserProfile({this.auth,this.user});
  String imageUrl;
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserModel user;
  Timer timer;
  CollectionReference users;
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
          imageUrl : doc.get("imageUrl"),
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
            setState((){
              user.avatarChild = CircleAvatar(
                backgroundImage: checkURL(widget.imageUrl),
                radius: 72,
              );
              widget.userDataRetrieved = false;
            });
          });
        }else{
          setState((){
            user.avatarChild = CircleAvatar(
              backgroundColor: Colors.blue,
              child: SpinKitThreeBounce(size: 40,color: Colors.white ,),
              radius: 72,
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
  void initState(){
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t){ 
      if(UserProfile.bookdeleted){
        setState(() {
          UserProfile.bookdeleted = false;
        });
      }
    });
    user = widget.user;
    users = DataBaseService().userCollection;
    users.doc(user.uid).get().then((DocumentSnapshot documentSnapshot)async {
      if (documentSnapshot.exists) {
        widget.username = await documentSnapshot.get("username");
        widget.email = await documentSnapshot.get("email");
        widget.location = await documentSnapshot.get("location");
        widget.imageUrl = await documentSnapshot.get("imageProfileUrl");
        if(!(widget.imageUrl=="" || widget.imageUrl == null)){
          user.avatarChild = CircleAvatar(
            backgroundImage: checkURL(widget.imageUrl),
            radius: 72,
          );
        }
        setState(() {
          widget.userDataRetrieved = true;
        });
      } else {
        print('Document does not exist on the database');
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    if(!widget.userDataRetrieved){
      users.doc(user.uid).get().then((DocumentSnapshot documentSnapshot)async {
      if (documentSnapshot.exists) {
        widget.username = await documentSnapshot.get("username");
        widget.email = await documentSnapshot.get("email");
        widget.location = await documentSnapshot.get("location");
        setState(() {
          widget.userDataRetrieved = true;
        });
      }
    });
    }
    return 
    ListView(
      children: [
        Column(
          crossAxisAlignment : CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children : [ 
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 280,
                  child: Image.asset("assets/userProfile.jpg",fit: BoxFit.cover,)
                ),
                Positioned(
                  top: 0,
                  right: 5,
                  child: Row(
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
                          )).then((value){this.setState(() {
                            widget.userDataRetrieved = false;
                          });});
                        },
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height : 20),
                    Stack(
                      children :[
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 75,
                          child: user.avatarChild==null?CircleAvatar(
                            backgroundColor : Colors.blue[400],
                            radius: 72,
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
                          child: GestureDetector(
                            child: CircleAvatar(
                              backgroundColor : Colors.blue,
                              radius : 20,
                              child : Icon(Icons.add_a_photo_rounded,color: Colors.white,size: 25,),
                            ),
                            onTap: () async{
                              await getImage(user, users);
                            }
                          )
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
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        //height: 150,
                        child : FutureBuilder(
                          future: buildBooks(user.uid),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if(snapshot.hasData){
                              return Column(children: snapshot.data);
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
          ],
        ),
      ],
    );
  }
}