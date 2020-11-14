import 'package:flutter/material.dart';
import 'package:safeworkout/screens/home_screen.dart';
import 'package:safeworkout/views/MapPage.dart';
import 'package:safeworkout/views/HomePage.dart';
import 'package:safeworkout/views/ExercisePage.dart';

void main(){
  runApp(MyApp());
} 

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'SafeWorkout';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

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
    HomePage(),
    
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
        backgroundColor: Colors.blue[700],
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

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
 
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        selectedItemColor: Colors.blue[300],
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
              leading: Icon(Icons.pie_chart),
              title: Text('Nutrition'),
            ),
            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Workout Plan'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      )
    );
  }
}