class Player {
  int id;
  String name;
  int optionIndex;

  Player({required this.name, required this.id, required this.optionIndex});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      optionIndex: json['optionIndex']
    );
  }

  Map<String, dynamic> toJson() =>
  {
    'name': name,
    'optionIndex': optionIndex
  };
}
