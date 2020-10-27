import 'package:flutter/material.dart';
import 'package:safeworkout/mapController.dart';
import 'package:safeworkout/webview_container.dart';
void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

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
    /*Text(
      'Index 0: Home',
      style: optionStyle,
    ),*/
    WebViewContainer('https://www.coachmag.co.uk/workouts/home-workouts', 'Home Workouts'),
    Text(
      'Index 1: QrCode',
      style: optionStyle,
      //searchBar()
    ),
    /*Text(
      'Index 2: Map',
      style: optionStyle,
    ),*/
    mapController()
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
        backgroundColor: Colors.red,
        title: !isSearching 
                ? Text('SafeWorkout')
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
            icon: Icon(Icons.qr_code),
            label: 'QrCode',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      
      drawer: Drawer(
        
        child: ListView(
            
          padding: EdgeInsets.zero,
          
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'SafeWorkout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
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