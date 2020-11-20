import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safeworkout/screens/home_screen.dart';
import 'package:safeworkout/views/MapPage.dart';
import 'package:safeworkout/views/FeedPage.dart';
import 'package:safeworkout/views/FavoritesPage.dart';
import 'package:safeworkout/globals.dart' as globals;
import 'package:safeworkout/views/YoutubeChannelFeed.dart';

import 'LogIn.dart';


/// This is the main application widget.
class HomePage extends StatelessWidget {
  static const String _title = 'SafeWorkout';
  const HomePage();

  @override
  Widget build(BuildContext context) {
    globals. isLogged= globals.user==null ? false: true;
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  //MyStatefulWidget();

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    // Home page
    home(),
    
    // Second page
    FeedPage(),

    // Map page
    MapPage()

    //video Page
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[100],
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

      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
        /*decoration: BoxDecoration(
          image:DecorationImage(
            image: AssetImage("images/TrainersBackground.png"),
            fit: BoxFit.cover
            ),
          ),*/
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[400],
        onTap: _onItemTapped,
      ),
      
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
              title: Text('Favorite Exercises'),
              enabled: globals.isLogged,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage()));
              }
            ),
            ListTile(
              leading: Icon(Icons.video_collection_outlined, color: Colors.green[300],),
              title: Text('Workout Videos'),
              enabled:true,// globals.isLogged,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeVPage()));
              },
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
        ),
      )
    );
  }
}

Widget home() {
  return Container(
    margin: EdgeInsets.all(5.0),
    padding: EdgeInsets.all(10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: 
            Text("Workout categories",
              style: TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontWeight: FontWeight.bold
              ),)
        ),

        Card(
          elevation: 5.0,
          margin: EdgeInsets.all(10.0),
          child: Container(
            padding: EdgeInsets.all(10.0),
            width: 400,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/TrainersBackground.png"),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Text("YOUR TEXT"),
          ),
        ),

        RaisedButton(
          color: Colors.red,
                elevation: 5.0,
                /*shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),*/
          child: Text("text"),
          onPressed: () {},
        )
        
        /*Text("Browse through exercises sorted by category.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          )
        ),*/

        /*Row(
          children: [
            Text("Browse through exercises sorted by category.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )
            ),
          ]
        ,),

        ListTile(
          title: 
            Text("Browse through exercises sorted by category.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              )
            ),
          trailing: CircleAvatar(
            backgroundColor: Colors.white,
              child: Icon(
              Icons.fitness_center,
              color: Colors.red,
              size: 35,
            ),
          )
        )*/
      ],
    )
  );
}

Future signOut() async{
  try {
    User user= (await FirebaseAuth.instance.currentUser);
    await FirebaseAuth.instance.signOut();
    return user.uid;
  } catch(e) {
    print(e.toString());
    return null;
  }
}