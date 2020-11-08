import 'package:safeworkout/api/ApiHandler.dart';
import 'package:safeworkout/ExerciseInfo.dart';

class ExerciseRepo {
  //final String _apiKey = apiKey;

  ApiHandler _handler = ApiHandler();

  Future<List<Exercise>> fetchExerciseList() async {
    final response = await _handler.get("exercise/?language=2&limit=387");
    return ExerciseInfo.fromJson(response).results;
  }
}