import 'package:flutter/material.dart';
import 'package:safeworkout/globals.dart' as globals;
import 'package:safeworkout/views/FavoritesPage.dart';
import 'package:safeworkout/views/HomePage.dart';
import 'package:safeworkout/views/LogIn.dart';
import 'package:html/parser.dart' show parse;

class ExerciseInfoPage extends StatefulWidget {
  String image;
  String name;
  String description;
  String categoryName;

  ExerciseInfoPage(String image, String name, String description, String categoryName) {
    this.image = image;
    this.name = name;
    this.description = description;
    this.categoryName = categoryName;
  }

  @override _ExerciseInfoPageState createState() => _ExerciseInfoPageState();

}

class _ExerciseInfoPageState extends State<ExerciseInfoPage> {

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:globals.myAppBar,
      body: 
      WillPopScope(
          onWillPop: _onBackPressed,
          child:SingleChildScrollView(
          child:
      Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ]
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Exercise Description", 
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    )
                  )
                ) 
              ],
            ),
            
            Container(  
              margin: EdgeInsets.only(top:20, left:20, right:20),
              padding: EdgeInsets.all(20),
              width: 350,
              color: Colors.blue[800],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.name, 
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  Text(widget.categoryName, 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom:20),
              padding: EdgeInsets.all(20),
              width: 350,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueGrey[800]
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(widget.image, height: 130,),
                  Divider(
                    height: 30,
                  ),
                    Text(parse(widget.description).body.text,
                      style: TextStyle(fontSize: 17),
                  )       
                ],
              ),
            ),
          ]
        ),      
      )
      ),
    ),
    drawer:globals.myDrawer(context),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)  {
                  return  HomePage();
                }));                },
              ),
            ],
          );
        });
  }
}