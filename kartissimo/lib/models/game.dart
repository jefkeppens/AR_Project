class Game {
  int id;
  double beforeTime;
  int playerId;


  Game({required this.id, required this.beforeTime, required this.playerId});

  double get time {
    return beforeTime;
  }

  set time(double value) {
    if (value > 0) {
      beforeTime = value;
    }
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      beforeTime: json['beforeTime'],
      playerId: json['playerId'],
    );
  }

  Map<String, dynamic> toJson() =>
  {
    'beforeTime': beforeTime,
    'playerId': playerId,
  };
}
