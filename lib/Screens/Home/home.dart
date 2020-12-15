import 'package:bookhub/Screens/Home/addBook.dart';
import 'package:bookhub/Screens/Home/userprofile.dart';
import 'package:bookhub/Services/Auth.dart';
import 'package:bookhub/models/user.dart';
import 'package:bookhub/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:bookhub/Services/database.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:provider/provider.dart";

class Home extends StatefulWidget {
  User_ user;
  Home({this.user});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  bool userprofileOn = false;
  bool searchBarOn = false;
   
  Future<String> getOwnerFromBook(String uid) async{
    String owner = await
      DataBaseService().userCollection.doc(uid).get().then((value){
        if (value.exists) {
          return value.get("username");
        } else {
          return "unkown";
        }
      });
    return owner;
  }

  Future<List<Widget>> buildBooks() async{
    List<Widget> test = await DataBaseService().bookCollection.limit(20).get().then((value)
    {
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
            padding: const EdgeInsets.fromLTRB(10,10,10,0),
            child: Container(
              padding: EdgeInsets.all(10),
              height: 150,
              width: MediaQuery.of(context).size.width,
              color: Colors.indigo[50],
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 150,
                    child : Image(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/addBook.jpg"),
                    )
                  ),
                  SizedBox(width : 10),
                  Container(
                    width: 190,
                    child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row(children: [
                        Text("Ttile : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(title.length>20?title.substring(0,20)+"...":title)
                      ],),
                      Row(children: [
                        Text("Author : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(author.length>17?author.substring(0,17)+"...":author)
                      ],),
                      Row(children: [
                        Text("category : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(category.length>16?category.substring(0,16)+"...":category)
                      ],),
                      Row(children: [
                        Text("Number of pages : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text((doc.get("pageNumbers").toString()))
                      ],),
                      Row(children: [
                        Text("Location : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(location.length>17?location.substring(0,17)+"...":location)
                      ],),
                      SizedBox(height : 2),
                      Container(
                        width: 200,
                        child: FlatButton(onPressed: 
                        (){
                          
                        }, 
                        color: Colors.blue,
                        child: Text("Contact owner",style: TextStyle(color: Colors.white),)),
                      )
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
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_>(context);
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
                height : MediaQuery.of(context).size.height-(MediaQuery.of(context).padding.top + kToolbarHeight + MediaQuery.of(context).viewInsets.bottom),
                child: ListView(
                  children: [
                    SizedBox(height : 70),
                    FutureBuilder(
                      future: buildBooks(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if(snapshot.hasData){
                          return Column(children: snapshot.data);
                        }else{
                          return Container(padding: EdgeInsets.fromLTRB(0, 150, 0, 0), child : SpinKitRipple(color: Colors.blue,size: 150,));
                        }
                      },
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
        ],),   
        floatingActionButton: userprofileOn?null:FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
            builder:(_)=>AddBook(books : DataBaseService().bookCollection,user : user)
            ));
          },
          child: Icon(Icons.add),
        )
      ),
    );
  }
}