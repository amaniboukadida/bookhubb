import 'dart:io';

import 'package:bookhub/Services/database.dart';
import 'package:bookhub/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:image/image.dart" as Img;
import 'package:image_picker/image_picker.dart';
// ignore: must_be_immutable
class AddBook extends StatefulWidget {
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

  @override

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

  Future getImage(String docUid, CollectionReference books) async{
    String fileName = docUid;
    Reference storageRef = FirebaseStorage.instance.ref().child("user-sProfiles").child(fileName);
    // ignore: deprecated_member_use
    var tempImage = await picker.getImage(source: ImageSource.gallery,maxHeight:  400 , maxWidth: 400);
    sampleImage = File(tempImage.path);
    if(sampleImage!=null){
      if(!(widget.imageUrl=="" || widget.imageUrl==null)){
        await storageRef.delete();
        await books.doc(docUid).update({"imageUrl":null});
      }
      uploadTask = storageRef.putFile(sampleImage);
      uploadTask.snapshotEvents.listen((event) async {
        if(event.state==TaskState.success){
          widget.imageUrl = await storageRef.getDownloadURL();
          books.doc(docUid).update({"imageUrl":widget.imageUrl}).then((value){
            print("done !!!!!");
            setState((){
              widget.currentPicture = Image(
                fit: BoxFit.cover,
                image:checkURL(widget.imageUrl)
              );
            });
          });
        }else{
          setState((){
            widget.currentPicture = Container(
              color: Colors.blue,
              child: SpinKitThreeBounce(size: 40,color: Colors.white ,),
            );
          });
        }
      });
    }
  }

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
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    height: 250,
                    child: widget.currentPicture
                  )),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
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
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  validator: (val){
                    return val.isEmpty? "Enter a category" : null;
                  },
                  onChanged: (val){
                    setState(() {
                      category = val;
                    });
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'category',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
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
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Add book'),
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    DataBaseService().updateBooksData(title:title, author:author, pageNumbers:pageNumbers, genre:category, location: widget.user.location,uid: widget.user.uid);
                    Navigator.pop(context);
                  }
                },
              )
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