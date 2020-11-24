import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safeworkout/globals.dart' as globals;

import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
  
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<NavigatorState> _key = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  final FirebaseAuth _auth = FirebaseAuth.instance;


bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  
Future<User> validateAndSubmit() async{
  //User user;

  if (validateAndSave()){
    try {
       globals.user= (await _auth.signInWithEmailAndPassword(
        email: _email,
        password:_password
      )).user;
    }on FirebaseAuthException catch(e) {
      print('Code message e: ${e.code}');
      print(e.message);
      _showAlertDialog(e.message);
    }
    if(globals.user.uid!=null){
      Navigator.push(context, MaterialPageRoute(builder: (context)  {
      return  HomePage();
      }));
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
  return globals.user; 
}

Future<void>enterAsGuest()async{
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return  HomePage();
    }));
  
}
void _showAlertDialog(String message) async {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        
      // key: _key,
       resizeToAvoidBottomPadding: false,
       body:WillPopScope(
        
         key: _key,
         onWillPop: _onBackPressed,
         child: Form(
         key: _formKey,
         child: Column(
           
           children: <Widget>[
             Container(
               height: 300,
               padding: const EdgeInsets.symmetric(horizontal: 43.0),

              // width: 500,
               decoration:BoxDecoration(
                 image:DecorationImage(
                   image:AssetImage('images/GymBackground1.png'),
                   fit:BoxFit.fill 
                   )
                ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      child:Center(
                        child: Text ("SafeWorkout",style:TextStyle(color: Colors.white,fontSize:35,fontWeight: FontWeight.bold)),
                      ),
                      )
                  )
                ],
                ),
             ),
             Padding(
	              padding: EdgeInsets.all(5.0),
	              child: Column(
	                children: <Widget>[
	                   Container(
	                    padding: EdgeInsets.all(5),
                      child: Column(
	                      children: <Widget>[
	                            padded(
                                child: TextFormField(
                                onChanged:(val)=>_email = val ,
                                key: new Key('email'),
                                decoration: new InputDecoration(hintText: 'Email',hintStyle:TextStyle(color: Colors.grey[400]) ),
                                autocorrect: true,
                                validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
                                ),
	                          ),
	                            padded(
                                child:TextFormField(
                                key: new Key('password'),
                                decoration: new InputDecoration(hintText: 'Password',),
                                obscureText: true,
                                autocorrect: false,
                                validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
                                onChanged:(val)=>_password = val ,
	                          ),
	                        )
	                      ],
	                    ),
	                  ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
	                    child:new RaisedButton(
                      key: new Key('need-login'),
                      child: Center(
	                      child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                      color: Colors.black26,
                      onPressed: validateAndSubmit,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0))     
	                    ),	
                    ),
                   Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
	                    child:new RaisedButton(
                      key: new Key('need-login'),
                      child: Center(
	                      child: Text("Enter as a guest", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                      color: Colors.black26,
                      onPressed: (){
                        _email="";
                        _password="";
                        //validateAndSubmit();
                        globals.user=null;
                        enterAsGuest();

                      },
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0))     
	                    ),	
                    )
	                ],
	              ),
	            )
	          ],
	        ),
	      ),
      )
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
     
      Widget padded({Widget child}) {
        return new Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: child,
        );
      }
}
