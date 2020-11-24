import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safeworkout/screens/home_screen.dart';
import 'package:safeworkout/views/MapPage.dart';
import 'package:safeworkout/views/FeedPage.dart';
import 'package:safeworkout/views/FavoritesPage.dart';
import 'package:safeworkout/globals.dart' as globals;
import 'package:safeworkout/views/YoutubeChannelFeed.dart';
import 'package:safeworkout/views/SharePage.dart';

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
  static List<Widget> bottomwidgetOptions = <Widget>[
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
      globals.bottomwidgetOptions=bottomwidgetOptions;
      globals.updateFavorite();

    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar:globals.myAppBar= myAppBar(context),
      body: Container(
        child: bottomwidgetOptions.elementAt(_selectedIndex),
        /*decoration: BoxDecoration(
          image:DecorationImage(
            image: AssetImage("images/TrainersBackground.png"),
            fit: BoxFit.cover
            ),
          ),*/
      ),
      bottomNavigationBar:globals.myBottomNavigationBar(context,_selectedIndex,_onItemTapped),
      drawer:globals.myDrawer(context),
    );
  }
}
Widget myAppBar(context){
   return AppBar(
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
      );
}


Widget home() {
  return SingleChildScrollView(
    child: Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => FeedPage()));
            },
            child: Card(
              elevation: 5.0,
              margin: EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                width: 400,
                height: 190,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/categories.jpg"),
                    //image: NetworkImage("https://img.freepik.com/free-vector/people-gym_52683-4075.jpg?size=626&ext=jpg"),
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.darken),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: 
                    Text("Explore exercise categories",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      ),)
                ),
              ),
            )
          ),

          InkWell(
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => FeedPage()));
            },
            child: Card(
              elevation: 5.0,
              margin: EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                width: 400,
                height: 190,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/home-workout.jpg"),
                    //image: NetworkImage("https://media.istockphoto.com/vectors/girl-watching-online-classes-on-laptop-and-doing-workout-at-home-vector-id1256291769?k=6&m=1256291769&s=612x612&w=0&h=svS-hNMzBPSXzD4rI3Q_x161QvtXyPIl4wUwUDd2SLI="),
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.darken),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: 
                    Text("Workout at home",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      ),)
                ),
              ),
            )
          ),

          InkWell(
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => FeedPage()));
            },
            child: Card(
              elevation: 5.0,
              margin: EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                width: 400,
                height: 190,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/park.jpg"),
                    //image: NetworkImage("https://media.istockphoto.com/vectors/urban-park-vector-id543805962?k=6&m=543805962&s=612x612&w=0&h=3JAmaFvUNsj7cVib2vGahjBegDYhmYK7R8gW24wheDI="),
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.darken),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: 
                    Text("Discover public spaces near",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      ),)
                ),
              ),
            )
          ),
          
        ],
      )
    ),
  );
}

