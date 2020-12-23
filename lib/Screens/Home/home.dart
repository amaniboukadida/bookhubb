import 'package:bookhub/Screens/Home/AddBook.dart';
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
  List<Widget> booksWidgets;
  List<QueryDocumentSnapshot> bookDocuments;
  String searchCategory = "All";
  String searchLocation = "All";
  final AuthService _auth = AuthService();
  bool userprofileOn = false;
  bool usernameRetrieved = false;
  bool filterOn = false;
  Query query;
  ScrollController _scrollController = ScrollController();
  Future<List<Widget>> buildBooks() async{
    if(searchCategory!="All"&&searchLocation!="All")
    {
      query = DataBaseService().bookCollection.limit(20).where("location", isEqualTo: searchLocation).where("genre",isEqualTo:searchCategory);
    }else if(searchCategory!="All"&&searchLocation=="All")
    {
      query = DataBaseService().bookCollection.limit(20).where("genre",isEqualTo:searchCategory);    
    }else if(searchCategory=="All"&&searchLocation!="All")
    {
      query = DataBaseService().bookCollection.limit(20).where("location",isEqualTo:searchLocation);
    }else{
      query = DataBaseService().bookCollection.limit(20);     
    }
    if(bookDocuments!=null){
      query.startAfter([bookDocuments]);
    }
    List<Widget> test = await query.get().then((value)
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
          screenId: 0,)//homescreen
        );
      }
      if(bookDocuments!=null){
        bookDocuments.addAll(value.docs);
      }else{
        bookDocuments=value.docs;
      }
      return test;
    });
    if(booksWidgets==null){
      booksWidgets = test;
    }else{
      booksWidgets.addAll(test);
    }
    return booksWidgets;
  }
  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(
      () {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double delta = 50.0; 
        if ( maxScroll - currentScroll <= delta) { 
            setState(() {
              print("added more books");
            });
        }
      }
    );
    final user = Provider.of<UserModel>(context);
    if(!usernameRetrieved)DataBaseService().userCollection.doc(user.uid).get().then((value) async { 
      user.username = await value.get("username");
      setState(() {
        usernameRetrieved = true;
      });
    });
    return Provider<CollectionReference>.value(
      value: DataBaseService().userCollection,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BookHub'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome ",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    Text(
                      "To BookHub !",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    SizedBox(height : 15),
                    Text(
                      user.username==null?" ":user.username,
                      textAlign : TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.blue, Colors.indigo[800]],
                  )
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: (){
                  setState(() {
                    Navigator.of(context).pop();
                    userprofileOn = false;
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: (){
                  setState(() {
                    userprofileOn = true;
                    Navigator.of(context).pop();
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text('Chat'),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('About BookHub'),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () => {_auth.signOut()},
              ),
            ],
          ),
        ),
        body: userprofileOn? UserProfile(auth : _auth): Column(children: [
          Stack(
            children: [
              GestureDetector(
                onTap: (){setState(() {
                  filterOn = false;
                });},
                child: Container(
                  height : MediaQuery.of(context).size.height-(MediaQuery.of(context).padding.top + kToolbarHeight + MediaQuery.of(context).viewInsets.bottom),
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      SizedBox(height : 70),
                      FutureBuilder(
                        future: buildBooks(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if(booksWidgets!=null){
                            return Column(children: booksWidgets);
                          }else{
                            return Container(padding: EdgeInsets.fromLTRB(0, 150, 0, 0), child : SpinKitRipple(color: Colors.blue,size: 150,));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.lightBlue[500],
                      ),
                      filterOn?Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          boxShadow: [BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),]
                        ),
                        height: 65,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children : [
                            Container(
                              width: MediaQuery.of(context).size.width/2,
                              height: 60,
                              padding: EdgeInsets.fromLTRB(5, 5, 2, 0),
                              child: DropdownButtonFormField<String>(
                                value: searchCategory,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  hintStyle: TextStyle(),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.blue[600],
                                      width: 2.0,
                                    ),
                                  ),
                                  labelText: 'category',
                                  ),
                                items: <String>["All","Action and adventure","Art/architecture","Business/economics",
                                "Children's","Crafts/hobbies","Classic","Cookbook","Comic book",
                                "Dictionary","Encyclopedia","Fantasy","Health/fitness","History","History fiction",
                                "Humor","Horror","Mystery","Philosophy","Poetry","Political","Religion",
                                "Romance","Science fiction","Science","Sports","Thriller"
                                ].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value,style: TextStyle(fontSize: 13),),
                                  );
                                }).toList(),
                                onChanged: (val) {searchCategory = val;},
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width/2,
                              height: 60,
                              padding: EdgeInsets.fromLTRB(2, 5, 5, 0),
                              child: DropdownButtonFormField<String>(
                                value: searchLocation,
                                validator: (val){
                                  return val.isEmpty? "Select your location" : null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  hintStyle: TextStyle(),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.blue[600],
                                      width: 2.0,
                                    ),
                                  ),
                                  labelText: 'location',
                                ),
                                items: <String>["All","Ariana","Béja","Ben Arous","Bizerte","Gabès",
                                "Gafsa","Jendouba","Kairouan","Kasserine","Kebili","Kef","Mahdia",
                                "Manouba","Medenine","Monastir","Nabeul","Sfax","Sidi Bouzid",
                                "Siliana","Sousse","Tataouine","Tozeur","Tunis","Zaghouan"].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value,style: TextStyle(fontSize: 13)),
                                  );
                                }).toList(),
                                onChanged: (val) {searchLocation = val;},
                              ),
                            ),
                          ]),
                        ],),
                      ):SizedBox(width : 0),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5,12,5,10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                filterOn = !filterOn;
                              });
                            },
                            child: Icon(
                              Icons.sort,color: Colors.white,
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          flex: 13,
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
                          flex: 3,
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
                                    onTap  : () {setState(() {
                                      filterOn=false;
                                      booksWidgets=null;
                                      bookDocuments=null;
                                    });},
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
          onPressed: ()async {
            await Navigator.push(context, MaterialPageRoute(
            builder:(_)=>AddBook(books : DataBaseService().bookCollection,user : user)
            ));
          },
          child: Icon(Icons.add),
        )
      ),
    );
  }
}