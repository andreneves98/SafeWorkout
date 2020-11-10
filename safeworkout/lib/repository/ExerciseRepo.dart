import 'package:safeworkout/api/ApiHandler.dart';
import 'package:safeworkout/backend/ExerciseInfo.dart';
import 'package:safeworkout/backend/ExerciseImageInfo.dart';

class ExerciseRepo {
  //final String _apiKey = apiKey;

  ApiHandler _handler = ApiHandler();

  // Fetch exercise list
  Future<List<Exercise>> fetchExerciseList() async {
    final response = await _handler.get("exercise/?language=2&limit=387");
    return ExerciseInfo.fromJson(response).results;
  }

  // Fetch exercises' images list
  Future<List<ExerciseImage>> fetchExerciseImageList() async {
    final response = await _handler.get("exerciseimage/?limit=204");
    return ExerciseImageInfo.fromJson(response).results;
  }
}