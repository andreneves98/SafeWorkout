import 'package:firebase_database/firebase_database.dart';
import 'package:safeworkout/backend/ExerciseInfo.dart';

import 'package:safeworkout/globals.dart' as globals;


DatabaseReference saveExercise(Exercise exercise){

  var id=globals.firebaseExList.child('users/').child(globals.user.uid).child(exercise.name);
  id.set(exercise.toJson());
  print(id.key);
  return id;
}

Future<void> removeExercise(Exercise exercise){

  var id=globals.firebaseExList.child('users/').child(globals.user.uid).child("${exercise.name}").remove();
  //print("NAME:");
  //print(exercise.name);
  return id;
}