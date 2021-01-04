import 'package:bookhub/Services/Auth.dart';
import 'package:bookhub/shared/loading.dart';
import "package:flutter/material.dart";

class Register extends StatefulWidget {
  final Function toggelView;
  Register({this.toggelView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  String email;
  String password;
  String retypedPassword;
  String username;
  String location;
  String error="";
  bool loading = false;
  final _formKey = GlobalKey<FormState>(); 
  @override
  Widget build(BuildContext context) {
    return loading? Loading():Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('BookHub'),
        actions: [
          FlatButton.icon(
            onPressed: (){
              widget.toggelView();
            }, 
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ), 
            label: Text(
              "Sign in",
              style: TextStyle(color: Colors.white),
              )
            )
        ],
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
                    height: 220,
                    child: Image(
                      fit: BoxFit.cover,
                      image:AssetImage("assets/register.jpg")
                    ),
                  )),
              Container(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child: TextFormField(
                  validator: (val){
                    return val.isEmpty? "Enter an email" : null;
                  },
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },
                  /*decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email address"
                  ),*/
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText : "Email address",
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: TextFormField(
                  validator: (val){
                    return val.isEmpty? "Enter a password" : val.length>5? null:"Enter a 6+ chars password";
                  },
                  onChanged: (val){
                    setState(() {
                      password = val;
                    });
                  },
                  obscureText: true,
                  /*decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),*/
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText : "Password",
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: TextFormField(
                  validator: (val){
                    return val.isEmpty? "Enter a password" : val==password? null:"Password not match";
                  },
                  onChanged: (val){
                    setState(() {
                      retypedPassword = val;
                    });
                  },
                  obscureText: true,
                  /*decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Retype password',
                  ),*/
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText : "Retype password",
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: TextFormField(
                  validator: (val){
                    return val.length < 5? "Username must be 5+ characters" : null;
                  },
                  onChanged: (val){
                    setState(() {
                      username = val;
                    });
                  },
                  obscureText: false,
                  /*decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),*/
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText : "Username",
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: DropdownButtonFormField<String>(
                  validator: (val){
                    return val.isEmpty? "Select your location" : null;
                  },
                  /*decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'location',
                    ),*/
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText : "location",
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.black54,
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
                  onChanged: (val) {location = val;},
                ),
              ),
              SizedBox(height : 5),
              Container(
              height: 50,
              width: 100,
              padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
              child: RaisedButton(
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0), 
                ),
                color: Colors.blue,
                child: Text('Sign up'),
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _auth.registerWithEmail(email,username, password,location);
                    if(result == null)
                    {
                      loading = false;
                      setState(() {
                        error = "please supply a valid email address";
                      });
                    }else{
                      setState(() {
                        error = "";
                      });
                    }
                  }
                },
              )
            ),
            SizedBox(height : 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children : [
                Text(
                  error,
                  style: TextStyle(color: Colors.red)
                ),]
              ),
            ]
          )
        )
      )
    );
  }
}