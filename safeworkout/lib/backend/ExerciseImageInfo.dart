class ExerciseImageInfo {
  int totalResults;
  List<ExerciseImage> results;
  
  ExerciseImageInfo({this.totalResults, this.results});

  ExerciseImageInfo.fromJson(Map<String, dynamic> json) {
    totalResults = json['count'];
    if (json['results'] != null) {
      results = new List<ExerciseImage>();
      json['results'].forEach((v) {
        results.add(new ExerciseImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalResults'] = this.totalResults;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExerciseImage {
  int id;
  String image;
  int exercise; // is the same as the ID in the exercise list

  ExerciseImage({this.id, this.image, this.exercise});
  
  ExerciseImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    exercise = json['exercise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['exercise'] = this.exercise;
    
    return data;
  }
}

