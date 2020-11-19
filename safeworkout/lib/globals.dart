library safeworkout.globals;
import 'package:safeworkout/backend/ExerciseInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<Exercise> favorites = new List();
User user;
bool isLogged;