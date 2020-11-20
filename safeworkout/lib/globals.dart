library safeworkout.globals;
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