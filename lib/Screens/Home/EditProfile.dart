import 'package:bookhub/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  
  final CollectionReference users;
  final UserModel user;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Edit profile",
        style: TextStyle(fontSize:18 ,color: Colors.black) ,),

      ),
      body: Form(
        key : _formKey,
        child: Column(
          children: [
            Stack( children : [
                Container(
                  child: Image(
                    image: AssetImage("assets/userProfile.jpg")
                  )
                ),
                Column(children: [
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
                       
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText : "Username",
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: DropdownButtonFormField<String>(
                      iconEnabledColor: Colors.black,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: 'location',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
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
                  SizedBox(height : 15),
                  Container(
                    height: 50,
                    width: 100,
                    child: FlatButton(
                      textColor: Colors.black,
                      color: Colors.white,
                      child: Text('Save' ),
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
                  
                ],)
              ]
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                height: 250,
                child: Image(
                  fit: BoxFit.cover,
                  image:AssetImage("assets/editProfile.jpg")
                ),
              )
            )
            
          ],
        ),
      ),
    );
  }
}