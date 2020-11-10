import 'dart:async';
import 'package:safeworkout/api/ApiResponse.dart';
import 'package:safeworkout/repository/ExerciseRepo.dart';
import 'package:safeworkout/backend/ExerciseInfo.dart';
import 'package:safeworkout/backend/ExerciseImageInfo.dart';
import 'package:rxdart/rxdart.dart';

class ExerciseBloc {  
  List<Exercise> exercises;
  List<ExerciseImage> images;
  ExerciseRepo _exerciseImageRepository;

  StreamController _exerciseImageListController = StreamController.broadcast();

  StreamSink<ApiResponse<List<Exercise>>> get exerciseImageListSink =>
      _exerciseImageListController.sink;

  Stream<ApiResponse<List<Exercise>>> get exerciseImageListStream =>
      _exerciseImageListController.stream;


  ExerciseBloc() {
    _exerciseImageListController = StreamController<ApiResponse<List<Exercise>>>();
    _exerciseImageRepository = ExerciseRepo();
    //mergeImages(11);
  }  
  
  mergeImages([int category]) async{
    print(category);
    exerciseImageListSink.add(ApiResponse.loading('Fetching Exercises'));
    exercises = await _exerciseImageRepository.fetchExerciseList();
    images = await _exerciseImageRepository.fetchExerciseImageList();
    List<Exercise> exercises_images = [];
    for(var exercise in exercises) {
      for(var image in images) {
        if(image.exercise == exercise.id && exercise.description != null && exercise.category == category) {
          var newEx = Exercise(id: exercise.id, name: exercise.name, description: exercise.description, 
                                          category: exercise.category, muscles: exercise.muscles, muscles_secondary: exercise.muscles_secondary, 
                                          image: image.image);
          exercises_images.add(newEx);
          /*if(!exercises_images.contains(element)
            exercises_images.add(newEx);
          }
          for(var ex in exercises_images) {
            if(ex.name != exercise.name) {
              exercises_images.add(newEx);
            }
          }    */     
        }
      }
    }
    print(exercises_images.length);

    try {
      exerciseImageListSink.add(ApiResponse.completed(exercises_images));
    } catch (e) {
      exerciseImageListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _exerciseImageListController?.close();
  }
}