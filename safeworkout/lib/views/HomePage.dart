import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safeworkout/screens/home_screen.dart';
import 'package:safeworkout/views/MapPage.dart';
import 'package:safeworkout/views/FeedPage.dart';

import 'LogIn.dart';


/// This is the main application widget.
class HomePage extends StatelessWidget {
  static const String _title = 'SafeWorkout';
  const HomePage({
    Key key, 
    this.user
    }) : super(key: key);

    final User user;

  @override
  Widget build(BuildContext context) {
    bool isLogged= this.user==null ? false: true;
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(isLogged:isLogged,user:user),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget(
    {
      Key key,
      this.user,
      this.isLogged,
    }) : super(key: key);
  
  final User user;
  final bool isLogged;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  bool isSearching=false;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    // Home page
    FeedPage(),
    
    // Second page
    HomeScreen(),

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
        
        backgroundColor: Colors.transparent,
        title: !isSearching 
                ? Text('SafeWorkout', style: TextStyle(fontSize: 26),)
                :TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search something here",
                    hintStyle: TextStyle(color: Colors.white))
                  
                ),
        
        actions:<Widget>[
          isSearching?
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: (){
              setState((){
                this.isSearching=false;
              });
            },
          ):
           IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              setState((){
                this.isSearching=true;
              });
            },
          ),
        ],
      ),

      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
        decoration: BoxDecoration(
          image:DecorationImage(
            image: AssetImage("images/TrainersBackground.png"),
            fit: BoxFit.cover
            ),
          ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_label),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
      
      drawer: Drawer(
        child: ListView(

          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 300,
              width: 200,
              child: DrawerHeader(
                child: Text(""),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  image: DecorationImage (
                    image: AssetImage('images/logo.jpg'),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_pin),
              title: this.widget.isLogged? 
                      Text('Sign as '+this.widget.user.email)
                      :Text('Guest'),
              
            ),
            ListTile(
              leading: Icon(Icons.pie_chart),
              title: Text('Nutrition'),
              
            ),
            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Workout Plan'),
              enabled: this.widget.isLogged,

            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              enabled: this.widget.isLogged,

            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Signout'),
              enabled: this.widget.isLogged,
              onTap: () async {
                  dynamic result=await signOut();
                  if(result==null){
                    print("There are no user logedIn");
                  }else{
                    print(result);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    }
              }), 
              ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favourite'),
              enabled: this.widget.isLogged,
            ),
          ],
        ),
      )
    );
  }
}

 Future signOut() async{
   try{
     User user= (await FirebaseAuth.instance.currentUser);
     await FirebaseAuth.instance.signOut();
     return user.uid;
    }catch(e){
      print(e.toString());
      return null;
    }
   }