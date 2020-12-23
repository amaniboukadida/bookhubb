import 'dart:io';

import 'package:bookhub/Screens/ContactOwner.dart';
import 'package:bookhub/Screens/Home/EditBook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
// ignore: must_be_immutable
class Book extends StatefulWidget {
  Widget currentPicture;
  String imageUrl;
  String author;
  String title;
  String category;
  String location;
  final String docUid;
  String ownerUid;
  int pageNumber;
  final int screenId; // 0 if home screen, 1 if user profile, 2 if book screen
  Book({this.author,this.title,this.category,this.location,this.docUid,this.ownerUid,this.pageNumber,this.screenId,this.imageUrl});
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  
  final picker = ImagePicker();
  UploadTask uploadTask;
  File sampleImage;

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

  Future getImage(String docUid, CollectionReference books) async{
    String fileName = docUid;
    Reference storageRef = FirebaseStorage.instance.ref().child("book-sImages").child(fileName);
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
              widget.currentPicture = CircleAvatar(
                backgroundImage: checkURL(widget.imageUrl),
                radius: 80,
              );
            });
          });
        }else{
          setState((){
            widget.currentPicture = CircleAvatar(
              backgroundColor: Colors.blue,
              child: SpinKitThreeBounce(size: 40,color: Colors.white ,),
              radius: 80,
            );
          });
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    switch (widget.screenId) {
      case 0 : //Home screen
        return Container(
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
                      image: checkURL(widget.imageUrl),
                    )
                  ),
                  SizedBox(width : 10),
                  Container(
                    width: 190,
                    child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row(children: [
                        Text("Ttile : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(widget.title.length>20?widget.title.substring(0,20)+"...":widget.title)
                      ],),
                      Row(children: [
                        Text("Author : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(widget.author.length>15?widget.author.substring(0,15)+"...":widget.author)
                      ],),
                      Row(children: [
                        Text("category : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(widget.category.length>16?widget.category.substring(0,16)+"...":widget.category)
                      ],),
                      Row(children: [
                        Text("Number of pages : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(widget.pageNumber.toString())
                      ],),
                      Row(children: [
                        Text("Location : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                        Text(widget.location.length>17?widget.location.substring(0,17)+"...":widget.location)
                      ],),
                      SizedBox(height : 2),
                      Container(
                        width: 200,
                        child: FlatButton(onPressed: 
                        (){
                          Navigator.push(context, MaterialPageRoute(
                          builder:(_)=>ContactOwner(ownerUid : widget.ownerUid)));
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
        );
      break;
      case 1 : return Stack(
          children:[ 
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10,0,0,0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  
                  height: 130,
                  width: 250,
                  color: Colors.blue[100],
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 120,
                        child : Image(
                          fit: BoxFit.cover,
                          image: checkURL(widget.imageUrl),
                        )
                      ),
                      SizedBox(width : 10),
                      Container(
                        width: 140,
                        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(children: [
                            Text("Ttile : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                            Text(widget.title.length>10?widget.title.substring(0,10)+"...":widget.title)
                          ],),
                          Row(children: [
                            Text("Author : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                            Text(widget.author.length>9?widget.author.substring(0,9)+"...":widget.author)
                          ],),
                          Row(children: [
                            Text("category : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                            Text(widget.category.length>8?widget.category.substring(0,8)+"...":widget.category)
                          ],),
                          Row(children: [
                            Text("Nbr of pages : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                            Text(widget.pageNumber.toString())
                          ],),
                          Row(children: [
                            Text("Location : ",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),),
                            Text(widget.location.length>10?widget.location.substring(0,10)+"...":widget.location)
                          ],)
                        ],),
                      ),
                    ],
                  ),
                ),
              ),
          ),
          Positioned(
            bottom: 6,
            right: 6,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                builder:(_)=>EditBook(this.widget)
                ));
              },
              child: Material(
              color: Colors.transparent,
              child: Ink(
                width: 75,
                height: 30,
                decoration: ShapeDecoration(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child : Center(
                  child: Text(
                    "Check",
                    style: TextStyle(fontSize: 13,color: Colors.white),
                  ),
                ),
              ),
            ),
          ), 
        )]
      );
      break;
    }
    return SizedBox();
  }
}