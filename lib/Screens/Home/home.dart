import 'package:bookhub/Screens/Home/addBook.dart';
import 'package:bookhub/Screens/Home/userprofile.dart';
import 'package:bookhub/Services/Auth.dart';
import 'package:bookhub/models/Book.dart';
import 'package:bookhub/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:bookhub/Services/database.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:provider/provider.dart";

// ignore: must_be_immutable
class Home extends StatefulWidget {
  UserModel user;
  Home({this.user});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  bool userprofileOn = false;
  bool searchBarOn = false;

  Future<List<Widget>> buildBooks() async{
    List<Widget> test = await DataBaseService().bookCollection.limit(20).get().then((value)
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
          screenId: 0,)//homescreen
        );
      }
      return test;
    });
    return test;
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
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