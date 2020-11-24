library safeworkout.globals;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:safeworkout/backend/ExerciseInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeworkout/models/channel_model.dart';
import 'package:safeworkout/views/FavoritesPage.dart';
import 'package:safeworkout/views/LogIn.dart';
import 'package:safeworkout/views/SharePage.dart';
import 'package:safeworkout/views/YoutubeChannelFeed.dart';

List<Exercise> favorites = new List();
User user;
bool isLogged;
String channelID ;
//Drawer drawer;
AppBar myAppBar;
List<Widget> bottomwidgetOptions;
Channel channel;
DatabaseReference firebaseExList=FirebaseDatabase.instance.reference();

Widget myBottomNavigationBar(context,_selectedIndex,_onItemTapped){
 
  return  BottomNavigationBar(
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
      );
}
bool favContainsExercise(Exercise exercise){
  for(var f in favorites){
   // print("ExerciseInList=${f.name}\t ${exercise.name}=Exercisechosed");
    if(f.name==exercise.name){
      return true;
    }
  }
  return false;
}

Future<void>  updateFavorite() async{
  // Navigator.pop();
  //print(user.uid);
 FirebaseDatabase.instance.reference().child("users/").child(user.uid).once().then((DataSnapshot snapshot){
        
        
        
      if(snapshot.value==null)favorites.clear();
      
      else{ 
        Map<dynamic,dynamic> map = snapshot.value;
       print("This is the print of the current user favs");

    
          print(map.keys);
          List<Exercise> listExercise=new List();
            for(var b in map.keys){
                List<dynamic> muscles=map[b]['muscles'] as List<dynamic>;
                List<dynamic>muscles_secondary=map[b]['muscles_secondary'] as List<dynamic>;
                String description=map[b]['description'];
                String image=map[b]['image'] ;
                List<dynamic> equipment=map[b]['equipment']as List<dynamic>;;
                String name=map[b]['name'];
                int category=map[b]['category'];
                int id=map[b]['id'];
                Exercise ex=new Exercise(id:id,description:description,name:name,category:category,
                muscles:muscles,muscles_secondary:muscles_secondary,equipment:equipment,image:image,favorite:true);
                listExercise.add(ex);     
              
            }
            favorites=listExercise;
       }
     });
}

String getFavoritesNames() {
  String names = "";
  for(var Exercise in favorites) {
    names += Exercise.name + ",";
  }

  return names;
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
              leading: isLogged ? CircleAvatar(backgroundImage: NetworkImage("https://banner2.cleanpng.com/20180626/fhs/kisspng-avatar-user-computer-icons-software-developer-5b327cc98b5780.5684824215300354015708.jpg"))
              : CircleAvatar(backgroundImage: NetworkImage("https://www.plataformadialetica.com/images/2020/04/10/team1.jpg")),
              title: Text("Signed in as"),
              subtitle: isLogged ? 
                      Text(user.email)
                      : Text('Guest'),
              
            ),

            Divider(
              height: 30,
            ),

            ListTile(
              leading: Icon(Icons.star_border, color: Colors.yellow[600],),
              title: Text('Favorite Exercises'),
              enabled: isLogged,
              onTap: () {
                updateFavorite();
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage()));
              }
            ),
            ListTile(
              leading: Icon(Icons.video_collection_outlined, color: Colors.green[300],),
              title: Text('Workout Videos'),
              enabled: isLogged,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeVPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.qr_code, color: Colors.blue[300],),
              title: Text('Share'),
              enabled: isLogged,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SharePage()));
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
                    isLogged ? 
                    Icon(Icons.logout, color: Colors.white,):
                    Icon(Icons.exit_to_app, color: Colors.white,),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child:isLogged ?
                        Text("Sign out", style: TextStyle(color: Colors.white),):
                        Text("Exit", style: TextStyle(color: Colors.white),)

                    )
                  ],
                ),
                onPressed: () async {
                  dynamic result=await signOut();
                  if(result==null) {
                    print("There are no user logedIn");
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
            )
            )
            
          ],
        ),
      );
}

Future signOut() async{
  try {
    user= (await FirebaseAuth.instance.currentUser);
    await FirebaseAuth.instance.signOut();
    return user.uid;
  } catch(e) {
    print(e.toString());
    isLogged=false;
    return null;
  }
}