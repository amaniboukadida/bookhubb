import 'package:bookhub/Services/database.dart';
import 'package:bookhub/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBook extends StatefulWidget {
  CollectionReference books;
  User_ user;
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
  @override
  Widget build(BuildContext context) {
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
                    child: Image(
                      fit: BoxFit.cover,
                      image:AssetImage("assets/addBook.jpg")
                    ),
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
                    DataBaseService().updateBooksData(title, author, pageNumbers, category, widget.user.location, widget.user.uid);
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