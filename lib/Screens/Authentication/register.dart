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
  String error="";
  bool loading = false;
  final _formKey = GlobalKey<FormState>(); 
  @override
  Widget build(BuildContext context) {
    return loading? Loading():Scaffold(
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
                    height: 250,
                    child: Image(
                      fit: BoxFit.cover,
                      image:NetworkImage("https://thewritelife.com/wp-content/uploads/2019/08/How-to-format-a-book.jpg")
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
                    labelText: "Email address"
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
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Retype password',
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
                child: Text('Sign up'),
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    setState(() {
                      loading = true;
                    }); 
                    dynamic result = await _auth.registerWithEmail(email, password);
                    if(result == null)
                    {
                      loading = false;
                      setState(() {
                        error = "please supply a valid email address";
                        print(error);
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
            SizedBox(height : 20),
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