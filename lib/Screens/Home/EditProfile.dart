import 'package:bookhub/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  
  final CollectionReference users;
  final User_ user;
  String username;
  String location;
  EditProfile({this.users, this.user});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  
  final _formKey = GlobalKey<FormState>(); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit profile"),
      ),
      body: Form(
        key : _formKey,
        child: ListView(children: [
          SizedBox(height : 25),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              validator: (val){
                return val.length<5? "Username must be 5+ characters" : null;
              },
              onChanged: (val){
                widget.username = val;
              },
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'location',
                ),
              items: <String>["Ariana","Béja","Ben Arous","Bizerte","Gabès",
              "Gafsa","Jendouba","Kairouan","Kasserine","Kebili","Kef","Mahdia",
              "Manouba","Medenine","Monastir","Nabeul","Sfax","Sidi Bouzid",
              "Siliana","Sousse","Tataouine","Tozeur","Tunis","Zaghouan"].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (val) {widget.location = val;},
            ),
          ),
          Container(
            height: 50,
            width: 100,
            padding: EdgeInsets.fromLTRB(100, 10, 100, 0),
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Save'),
              onPressed: (){
                if(_formKey.currentState.validate()){
                  widget.users.doc((widget.user.uid)).update({"username":widget.username,"location":widget.location});
                  widget.user.username = widget.username;
                  widget.user.location = widget.location;
                  Navigator.pop(context);
                }
              },
            )
          ),
        ],),
      ),
    );
  }
}