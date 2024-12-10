class Race {
  int id;
  String name;
  Difficulty difficulty;
  int distance;
  double beforeTimeLimit;

  Race({required this.id, required this.name, required this.difficulty, required this.distance,required this.beforeTimeLimit});

  double get timeLimit {
    return beforeTimeLimit;
  }

  set timeLimit(double value) {
    if (value > 0) {
      beforeTimeLimit = value;
    }
  }

  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      id: json['id'],
      name: json['name'],
      difficulty: json['difficulty'],
      distance: json['distance'],
      beforeTimeLimit: json['beforeTimeLimit']
    );
  }

  Map<String, dynamic> toJson() =>
  {
    'name': name,
    'difficulty': difficulty,
    'distance': distance,
    'beforeTimeLimit': beforeTimeLimit
  };
}

enum Difficulty {
  easy,moderate,hard;
}