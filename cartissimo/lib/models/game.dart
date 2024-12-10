class Game {
  int id;
  double beforeTime;
  double beforePenaltyTime;
  int playerId;
  int raceId;


  Game({required this.id, required this.beforeTime, required this.beforePenaltyTime, required this.playerId, required this.raceId});

  double get time {
    return beforeTime;
  }

  set time(double value) {
    if (value > 0) {
      beforeTime = value;
    }
  }

  double get pentalyTime {
    return beforePenaltyTime;
  }

  set pentalyTime(double value) {
    if (value > 0) {
      beforePenaltyTime = value;
    }
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      beforeTime: json['beforeTime'],
      beforePenaltyTime: json['beforePenaltyTime'],
      playerId: json['playerid'],
      raceId: json['raceId']
    );
  }

  Map<String, dynamic> toJson() =>
  {
    'beforeTime': beforeTime,
    'beforePenaltyTime': beforePenaltyTime,
    'playerId': playerId,
    'raceId': raceId
  };
}
