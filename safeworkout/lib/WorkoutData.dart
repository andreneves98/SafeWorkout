import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WorkoutData {

  Future<http.Response> fetchAlbum() {
  return http.get('https://jsonplaceholder.typicode.com/albums/1');
}

 static final muscleGroups = [
   {
     'name': 'Chest',
     'image': 'images/chest.jpg',
     'exercises': [

     ]
   },
   {
     'name': 'Abdomen',
     'image': 'images/abs.jpg'
   },
   {
     'name': 'Back',
     'image': 'images/back.jpg'
   },
   {
     'name': 'Shoulders',
     'image': 'images/shoulders.jpg'
   },
   {
     'name': 'Front Leg',
     'image': 'images/frontleg.jpg'
   },
   {
     'name': 'Triceps',
     'image': 'images/triceps.jpg'
   },
   {
     'name': 'Back Leg',
     'image': 'images/backleg.jpg'
   },
   {
     'name': 'Biceps',
     'image': 'images/biceps.jpg'
   },
   {
     'name': 'Gluteus',
     'image': 'images/gluteus.jpg'
   },
   {
     'name': 'Forearm',
     'image': 'images/forearm.jpg'
   },
 ];
}