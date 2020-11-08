import 'dart:async';
import 'package:safeworkout/api/ApiResponse.dart';
import 'package:safeworkout/repository/ExerciseRepo.dart';
import 'package:safeworkout/ExerciseInfo.dart';

class ExerciseBloc {
  ExerciseRepo _exerciseRepository;

  StreamController _exerciseListController;

  StreamSink<ApiResponse<List<Exercise>>> get exerciseListSink =>
      _exerciseListController.sink;

  Stream<ApiResponse<List<Exercise>>> get exerciseListStream =>
      _exerciseListController.stream;

  ExerciseBloc() {
    _exerciseListController = StreamController<ApiResponse<List<Exercise>>>();
    _exerciseRepository = ExerciseRepo();
    fetchExerciseList();
  }

  fetchExerciseList() async {
    exerciseListSink.add(ApiResponse.loading('Fetching Exercises'));
    try {
      List<Exercise> exercises = await _exerciseRepository.fetchExerciseList();
      exerciseListSink.add(ApiResponse.completed(exercises));
    } catch (e) {
      exerciseListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _exerciseListController?.close();
  }
}