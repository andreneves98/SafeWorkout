import 'package:flutter/material.dart';
import 'package:safeworkout/globals.dart' as globals;
import 'package:safeworkout/views/FavoritesPage.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.clear_all, color: Colors.black, size: 30,),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        title: Text("SafeWorkout", style: TextStyle(color: Colors.red[500], fontSize: 30),),
      ),
      body: SingleChildScrollView(
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
      )),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 270,
              width: 200,
              child: DrawerHeader(
                child: Text(""),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  image: DecorationImage (
                    image: AssetImage('images/logo.jpg'),
                    fit: BoxFit.fitWidth
                  )
                ),
              ),
            ),
            ListTile(
              leading: globals.isLogged ? CircleAvatar(backgroundImage: NetworkImage("https://banner2.cleanpng.com/20180626/fhs/kisspng-avatar-user-computer-icons-software-developer-5b327cc98b5780.5684824215300354015708.jpg"))
              : CircleAvatar(backgroundImage: NetworkImage("https://www.plataformadialetica.com/images/2020/04/10/team1.jpg")),
              title: Text("Signed in as"),
              subtitle: globals.isLogged ? 
                      Text(globals.user.email)
                      : Text('Guest'),
            ),

            Divider(
              height: 30,
            ),

            ListTile(
              leading: Icon(Icons.star_border, color: Colors.yellow[600],),
              title: Text('Favorites'),
              enabled: globals.isLogged,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage()));
              }
            ),
            ListTile(
              leading: Icon(Icons.pie_chart_outlined, color: Colors.green[300],),
              title: Text('Nutrition'),
              enabled: globals.isLogged,
            ),
            ListTile(
              leading: Icon(Icons.qr_code, color: Colors.blue[300],),
              title: Text('Share'),
              enabled: globals.isLogged,
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage()));
              }
            ),

            Divider(
              height: 30,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: RaisedButton(
                color: Colors.red,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white,),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Sign out", style: TextStyle(color: Colors.white),)
                    )
                  ],
                ),
                onPressed: () async {
                  dynamic result=await signOut();
                  if(result==null) {
                    print("There are no user logedIn");
                  } else {
                    print(result);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                },
              )
            )
          ],
        )
      ),
    );
  }
}