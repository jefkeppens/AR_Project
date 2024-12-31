class Player {
  int id;
  String name;

  Player({required this.name, required this.id});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() =>
  {
    'name': name,
  };
}
