library safeworkout.globals;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:safeworkout/backend/ExerciseInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeworkout/models/channel_model.dart';

List<Exercise> favorites = new List();
User user;
bool isLogged;
String channelID ;
Drawer myDrawer;
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