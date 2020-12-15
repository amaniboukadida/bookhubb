import 'package:bookhub/Services/Auth.dart';
import 'package:bookhub/shared/loading.dart';
import "package:flutter/material.dart";

class Sign_in extends StatefulWidget {
  final Function toggelView;
  Sign_in({this.toggelView});
  @override
  _Sign_inState createState() => _Sign_inState();
}

class _Sign_inState extends State<Sign_in> {
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
      appBar: AppBar(
        title: Text('BookHub'),
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User email',
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: loginFail ? "wrong username and password combination":null,
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(height : 10),
              Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Login'),
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