import 'dart:io';

import 'package:bookhub/Services/database.dart';
import 'package:bookhub/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
// ignore: must_be_immutable
class AddBook extends StatefulWidget {
  bool addBookClicked = false;
  Widget currentPicture;
  String imageUrl;
  final CollectionReference books;
  UserModel user;
  AddBook({this.user,this.books});
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final _formKey = GlobalKey<FormState>();
  String title;
  String author;
  String category;
  int pageNumbers;
  final picker = ImagePicker();
  UploadTask uploadTask;
  File sampleImage;

 
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

  Future getImage() async{
    // ignore: deprecated_member_use
    var tempImage = await picker.getImage(source: ImageSource.gallery,maxHeight:  400 , maxWidth: 400);
    sampleImage = File(tempImage.path);
    setState((){
      widget.currentPicture = Image(
        fit: BoxFit.cover,
        image:FileImage(sampleImage)
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    if(!(widget.imageUrl=="" || widget.imageUrl == null)){
      widget.currentPicture = Image(
        fit: BoxFit.cover,
        image:checkURL(widget.imageUrl)
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('AddBook'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Stack(
                children : [Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    height: 250,
                    child: widget.currentPicture==null?Image(image: AssetImage("assets/addBook.jpg"),fit: BoxFit.cover,):widget.currentPicture
                  )),
                  !widget.addBookClicked?Positioned(
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
                            await getImage();
                          }
                        )
                      ),
                    ), 
                  ):SizedBox(width:0)
                  ]

              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  readOnly: widget.addBookClicked?true:false,
                  validator: (val){
                    return val.isEmpty? "Enter the book title" : null;
                  },
                  onChanged: (val){
                    setState(() {
                      title = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Book title"
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextFormField(
                  readOnly: widget.addBookClicked?true:false,
                  validator: (val){
                    return val.isEmpty? "Enter the book author's name" :null;
                  },
                  onChanged: (val){
                    setState(() {
                      author = val;
                    });
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Book's author",
                  ),
                ),
              ),
              widget.addBookClicked?Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  initialValue: category,
                  readOnly: true,
                  validator: (val){
                    return val.isEmpty? "Select a category" : null;
                  },
                  onChanged: (val){
                    setState(() {
                      category = val;
                    });
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "category",
                  ),
                ),
              ):
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: DropdownButtonFormField<String>(
                  validator: (val){
                    return val.isEmpty? "Select a category" : null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'category',
                    ),
                  items: <String>["Action and adventure","Art/architecture","Business/economics",
                  "Children's","Crafts/hobbies","Classic","Cookbook","Comic book",
                  "Dictionary","Encyclopedia","Fantasy","Health/fitness","History","History fiction",
                  "Humor","Horror","Mystery","Philosophy","Poetry","Political","Religion",
                  "Romance","Science fiction","Science","Sports","Thriller"
                  ].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {category = val;},
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  readOnly: widget.addBookClicked?true:false,
                  keyboardType: TextInputType.number,
                  validator: (val){
                    return val.isEmpty? "Enter the number of pages" : null;
                  },
                  onChanged: (val){
                    setState(() {
                      pageNumbers = int.parse(val);
                    });
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Number of pages',
                  ),
                ),
              ),
              SizedBox(height : 20),
              Container(
              height: 50,
              width: 100,
              padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
              child: !widget.addBookClicked?RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Add book'),
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    setState(() {
                     widget.addBookClicked=true;
                    }); 
                    DocumentReference test = await DataBaseService().updateBooksData(title:title, author:author, pageNumbers:pageNumbers, genre:category, location: widget.user.location,uid: widget.user.uid);
                    Reference storageRef = FirebaseStorage.instance.ref().child("book-sImages").child(test.id);
                    if(sampleImage!=null){
                      uploadTask = storageRef.putFile(sampleImage);
                      uploadTask.snapshotEvents.listen((event) async {
                        if(event.state==TaskState.success){
                          widget.imageUrl = await storageRef.getDownloadURL();
                          widget.books.doc((test.id)).update({"imageUrl":widget.imageUrl}).then((value){
                          showDialog(
                            context: context,
                            builder: ((_) => 
                            AlertDialog(
                              title: Text("Book added successfully"),
                              content: Text("Click OK to continue"),
                              actions: [
                                FlatButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.cyan),
                                  ),
                                ),
                              ],
                            )
                          )); 
                          }
                          );
                        }else{
                          setState((){
                            widget.currentPicture = Container(
                              color: Colors.blue,
                              child: SpinKitThreeBounce(color: Colors.white,size: 45,),
                            );
                          });
                        }
                      });
                    }else{
                      await showDialog(
                        context: context,
                        builder: ((_) => 
                        AlertDialog(
                          title: Text("Book added successfully"),
                          content: Text("Click OK to continue"),
                          actions: [
                            FlatButton(
                              onPressed: (){
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(color: Colors.cyan),
                              ),
                            ),
                          ],
                        )
                      ));               
                    }
                  }
                },
              ):SizedBox(width:0)
            ),
            SizedBox(
              height : MediaQuery.of(context).viewInsets.bottom==0?0:MediaQuery.of(context).viewInsets.bottom
            )
            ]
          )
        )
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}