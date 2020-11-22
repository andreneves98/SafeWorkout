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
      drawer:globals.myDrawer= myDrawer(context),
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

Widget myDrawer(context){
  return  Drawer(
        
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
                    globals.isLogged ? 
                    Icon(Icons.logout, color: Colors.white,):
                    Icon(Icons.exit_to_app, color: Colors.white,),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child:globals.isLogged ?
                        Text("Sign out", style: TextStyle(color: Colors.white),):
                        Text("Exit", style: TextStyle(color: Colors.white),)

                    )
                  ],
                ),
                onPressed: () async {
                  dynamic result=await signOut();
                  if(result==null) {
                    print("There are no user logedIn");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                },
            )
            )
            
          ],
        ),
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
          /*Align(
            alignment: Alignment.topLeft,
            child: 
              Text("Explore exercise categories",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold
                ),)
          ),*/
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
                    //image: AssetImage("images/TrainersBackground.png"),
                    image: NetworkImage("https://img.freepik.com/free-vector/people-gym_52683-4075.jpg?size=626&ext=jpg"),
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
                    //image: AssetImage("images/TrainersBackground.png"),
                    image: NetworkImage("https://media.istockphoto.com/vectors/girl-watching-online-classes-on-laptop-and-doing-workout-at-home-vector-id1256291769?k=6&m=1256291769&s=612x612&w=0&h=svS-hNMzBPSXzD4rI3Q_x161QvtXyPIl4wUwUDd2SLI="),
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
                    //image: AssetImage("images/TrainersBackground.png"),
                    image: NetworkImage("https://media.istockphoto.com/vectors/urban-park-vector-id543805962?k=6&m=543805962&s=612x612&w=0&h=3JAmaFvUNsj7cVib2vGahjBegDYhmYK7R8gW24wheDI="),
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