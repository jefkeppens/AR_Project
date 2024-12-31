// class Race {
//   int id;
//   String name;
//   Difficulty difficulty;
//   int distance;
//   double beforeTimeLimit;

//   Race({required this.id, required this.name, required this.difficulty, required this.distance,required this.beforeTimeLimit});

//   double get timeLimit {
//     return beforeTimeLimit;
//   }

//   set timeLimit(double value) {
//     if (value > 0) {
//       beforeTimeLimit = value;
//     }
//   }

//   factory Race.fromJson(Map<String, dynamic> json) {
//     return Race(
//       id: json['id'],
//       name: json['name'],
//       difficulty: _difficultyFromString(json['difficulty']),
//       distance: json['distance'],
//       beforeTimeLimit: json['beforeTimeLimit']
//     );
//   }

//   Map<String, dynamic> toJson() =>
//   {
//     'name': name,
//     'difficulty': difficulty,
//     'distance': distance.toString(),
//     'beforeTimeLimit': beforeTimeLimit
//   };

//   static Difficulty _difficultyFromString(String difficulty) {
//     switch (difficulty.toLowerCase()) {
//       case 'easy':
//         return Difficulty.easy;
//       case 'moderate':
//         return Difficulty.moderate;
//       case 'hard':
//         return Difficulty.hard;
//       default:
//         throw ArgumentError('Unknown difficulty: $difficulty');
//     }
//   }
// }

// enum Difficulty {
//   easy,moderate,hard;
// }

