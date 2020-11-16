import 'dart:async';
import 'package:safeworkout/api/ApiResponse.dart';
import 'package:safeworkout/repository/ExerciseRepo.dart';
import 'package:safeworkout/backend/ExerciseInfo.dart';
import 'package:safeworkout/backend/ExerciseImageInfo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:safeworkout/globals.dart' as globals;

class ExerciseBloc {  
  List<Exercise> exercises;
  List<ExerciseImage> images;
  ExerciseRepo _exerciseImageRepository;
  //List<Exercise> exercises_images = new List();

  StreamController _exerciseImageListController;

  StreamSink get exerciseImageListSink =>
      _exerciseImageListController.sink;

  Stream get exerciseImageListStream =>
      _exerciseImageListController.stream;


  ExerciseBloc() {
    print("NEW BLOC!");
    _exerciseImageListController = new BehaviorSubject();
    _exerciseImageRepository = ExerciseRepo();
  }  
  
  mergeImages([int category]) async{
    print("FAVS LIST SIZE: " + globals.favorites.length.toString());
    if(!_isDisposed) {
      exerciseImageListSink.add(ApiResponse.loading('Fetching Exercises'));
      exercises = await _exerciseImageRepository.fetchExerciseList();
      images = await _exerciseImageRepository.fetchExerciseImageList();
      List<Exercise> exercises_images = new List();
      //var newEx;
      for(var exercise in exercises) {
        for(var image in images) {
          if(image.exercise == exercise.id && exercise.description != null && exercise.category == category) {
            var newEx = Exercise(id: exercise.id, name: exercise.name, description: exercise.description, 
                                              category: exercise.category, muscles: exercise.muscles, muscles_secondary: exercise.muscles_secondary, 
                                              image: image.image, favorite: exercise.favorite);
                                            
            for(var fav in globals.favorites) {
              if(fav.image == newEx.image) {
                newEx.favorite = true;
              }
            }

            exercises_images.add(newEx);
          }
        }
      }
      //print("exercises_images length: " + exercises_images.length.toString());

      try {
        exerciseImageListSink.add(ApiResponse.completed(exercises_images));
      } catch (e) {
        exerciseImageListSink.add(ApiResponse.error(e.toString()));
        print(e);
      }
    }
  }

  bool _isDisposed = false;
  dispose() {
    _exerciseImageListController?.close();
    _isDisposed = true;
  }
}