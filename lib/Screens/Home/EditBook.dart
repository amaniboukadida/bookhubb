import 'dart:io';
import 'package:bookhub/Services/database.dart';
import 'package:bookhub/models/Book.dart';
import 'package:bookhub/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class EditBook extends StatefulWidget {
  Book book;
  bool editBookClicked = false;
  bool saveClicked = false;
  Widget currentPicture;
  String imageUrl ;
  String title;
  String author;
  String category;
  String location;
  int pageNumber;
  EditBook(Book book){
    this.book = book;
    currentPicture = Image(
    fit: BoxFit.cover,
    image:checkURL(book.imageUrl));
    this.category = book.category;
    this.location = book.location;
    this.pageNumber = book.pageNumber;
    this.author = book.author;
    this.title = book.title;
  }
  ImageProvider checkURL(String url)
  {
    try {
      ImageProvider test = NetworkImage(url);
      return test;
    } catch (e) {
      ImageProvider test = AssetImage("assets/addBook.jpg");
      return test;
    }
  }
  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {

  final _formKey = GlobalKey<FormState>();
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
    return Scaffold(
      appBar: AppBar(
        title: !widget.editBookClicked?Text("Check book"):Text("Edit book"),
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
                  (!widget.saveClicked&&widget.editBookClicked)?Positioned(
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
                  readOnly: (!widget.saveClicked&&widget.editBookClicked)?false:true,
                  initialValue: widget.book.title,
                  validator: (val){
                    return val.isEmpty? "Enter the book title" : null;
                  },
                  onChanged: (val){
                    setState(() {
                      widget.title = val;
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
                  readOnly: (!widget.saveClicked&&widget.editBookClicked)?false:true,
                  initialValue: widget.book.author,
                  validator: (val){
                    return val.isEmpty? "Enter the book author's name" :null;
                  },
                  onChanged: (val){
                    setState(() {
                      widget.author = val;
                    });
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Book's author",
                  ),
                ),
              ),
              !(!widget.saveClicked&&widget.editBookClicked)?Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  readOnly: true,
                  initialValue: widget.book.category,
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
                  value: widget.book.category,
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
                  onChanged: (val) {widget.category = val;},
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  readOnly:  (!widget.saveClicked&&widget.editBookClicked)?false:true,
                  initialValue: widget.book.pageNumber.toString(),
                  keyboardType: TextInputType.number,
                  validator: (val){
                    return val.isEmpty? "Enter the number of pages" : null;
                  },
                  onChanged: (val){
                    setState(() {
                      widget.pageNumber = int.parse(val);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                  height: 50,
                  width: 120,
                  child: !widget.editBookClicked?
                    RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Edit book'),
                      onPressed: (){
                        setState(() {
                          widget.editBookClicked = true;
                        });
                      }
                    )
                    :RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Save'),
                      onPressed: () async{
                        if(_formKey.currentState.validate()){
                          setState(() {
                            widget.saveClicked=true;
                          }); 
                          DataBaseService().bookCollection.doc(widget.book.docUid).update({
                            "title" : widget.title,
                            "author" : widget.author,
                            "pageNumbers" : widget.pageNumber,
                            "genre" : widget.category,
                            "location" : widget.location,
                          });
                          Reference storageRef = FirebaseStorage.instance.ref().child("book-sImages").child(widget.book.docUid);
                          if(sampleImage!=null){
                            uploadTask = storageRef.putFile(sampleImage);
                            uploadTask.snapshotEvents.listen((event) async {
                              if(event.state==TaskState.success){
                                widget.book.imageUrl = await storageRef.getDownloadURL();
                                DataBaseService().bookCollection.doc(widget.book.docUid).update({"imageUrl":widget.book.imageUrl}).then((value){
                                  Navigator.pop(context,"test");
                                });
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
                            Navigator.pop(context,"test");
                          }
                        }
                      },
                    )
                  ),
                  !widget.editBookClicked?SizedBox(width : 10):SizedBox(width : 0),
                  !widget.editBookClicked?Container(
                  height: 50,
                  width: 120,
                  child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Delete book'),
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: ((_) => AlertDialog(
                          title: Text("Delete this book"),
                          content: Text("Are you sure ?"),
                          actions: [
                            FlatButton(
                              onPressed: () async{
                                Reference storageRef = FirebaseStorage.instance.ref().child("book-sImages").child(widget.book.docUid);
                                if(!(widget.book.imageUrl=="" || widget.book.imageUrl==null)){
                                  await storageRef.delete();
                                }     
                                await DataBaseService().bookCollection.doc(widget.book.docUid).delete();
                                Navigator.pop(context);
                                Navigator.pop(context); 
                              },
                              child: Text(
                                "Yes",
                                style: TextStyle(color: Colors.cyan),
                              ),
                            ),
                            FlatButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text(
                                "No",
                                style: TextStyle(color: Colors.cyan),
                              ),
                            )
                          ],
                        ))
                        );
                      }
                    )
                  ):SizedBox(width:0),
                  widget.editBookClicked?SizedBox(width : 10):SizedBox(width : 0),
                  widget.editBookClicked?Container(
                  height: 50,
                  width: 120,
                  child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Cancel'),
                      onPressed: (){
                        setState(() {
                          widget.editBookClicked = false;
                        });
                      }
                    )
                  ):SizedBox(width:0)
                ],
              ),
            SizedBox(
              height : MediaQuery.of(context).viewInsets.bottom==0?0:MediaQuery.of(context).viewInsets.bottom
            )]
          )
        )
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}