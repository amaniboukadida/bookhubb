import 'package:bookhub/Services/Auth.dart';
import 'package:bookhub/shared/loading.dart';
import "package:flutter/material.dart";

class SignIn extends StatefulWidget {
  final Function toggelView;
  SignIn({this.toggelView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email ;
  String password;
  String error ="";
  bool loginFail = false;
  @override
  Widget build(BuildContext context) {
    return loading? Loading():Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'BookHub',
          style: TextStyle( color: Colors.black,fontSize:30 )
          ),
    
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
                    image:AssetImage("assets/signIn.jpg")
                  ),
                )),
            Container(
              padding: EdgeInsets.all(10),
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
                  labelText: 'User email',
                ),*/
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                  ),
                  labelText : "User email",
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
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                  errorText: loginFail ? "wrong username and password combination":null,
                  labelText: 'Password',
                ),*/
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  errorText: loginFail ? "wrong username and password combination":null,
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
            SizedBox(height : 10),
            Container(
              height: 50, 
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                textColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0), 
                ),
                color: Colors.white,
                child: Text(
                  'Login',
                  style: TextStyle(fontSize:18 )
                  ),
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    setState(() {
                      loading = true;
                    }); 
                    dynamic result = await _auth.signInWithEmail(email, password);
                    if(result==null)
                    {
                      setState(() {
                        loading = false;
                        error = "could not sign in";
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
            Container(
              child: Row(
                children: <Widget>[
                  Text('Does not have account?'),
                  FlatButton(
                    textColor: Colors.blue,
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                       widget.toggelView();
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                ),
              )
            ],)],
          ),
        )
      )
    );
  }
}