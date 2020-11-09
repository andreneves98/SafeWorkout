class ExerciseInfo {
  int totalResults;
  List<Exercise> results;
  
  ExerciseInfo({this.totalResults, this.results});

  ExerciseInfo.fromJson(Map<String, dynamic> json) {
    totalResults = json['count'];
    if (json['results'] != null) {
      results = new List<Exercise>();
      json['results'].forEach((v) {
        results.add(new Exercise.fromJson(v));
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

class Exercise {
  int id;
  String description;
  String name;
  int category;
  List<dynamic> muscles;
  List<dynamic> muscles_secondary;
  List<dynamic> equipment;
  String image;

  Exercise({this.id, this.description, this.name, this.category, this.muscles, 
            this.muscles_secondary, this.equipment, this.image});
  
  Exercise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    name = json['name'];
    category = json['category'];
    muscles = json['muscles'];
    muscles_secondary = json['muscles_secondary'];
    equipment = json['equipment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['name'] = this.name;
    data['category'] = this.category;
    data['muscles'] = this.muscles;
    data['muscles_secondary'] = this.muscles_secondary;
    data['equipment'] = this.equipment;

    return data;
  }
}

