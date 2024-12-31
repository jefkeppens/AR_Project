import 'package:kartissimo/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/player.dart';

class PlayerApi {
  static Future<List<Player>> fetchPlayers() async {
    var url = Uri.https(globalServer, '/players');

    final response = await http.get(url, 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '49654'
      },);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((player) => Player.fromJson(player)).toList();
    } else {
      throw Exception('Failed to load players');
    }
  }

  static Future<Player> fetchPlayer(int id) async {
    var url = Uri.https(globalServer, '/players/$id');

    final response = await http.get(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '49654'
      },);
    if (response.statusCode == 200) {
      return Player.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load player');
    }
  }

    static Future<Player> createPlayer(Player player) async {
    var url = Uri.https(globalServer, '/players');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '49654'
      },
      body: jsonEncode(player),
    );
    if (response.statusCode == 201) {
      return Player.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create player');
    }
  }

    static Future<Player> updatePlayer(int id, Player player) async {
    var url = Uri.https(globalServer, '/players/$id');

    final http.Response response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '49654'
      },
      body: jsonEncode(player),
    );
    if (response.statusCode == 200) {
      return Player.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update player');
    }
  }

    static Future deletePlayer(int id) async {
    var url = Uri.https(globalServer, '/players/$id');
    
    final http.Response response =
        await http.delete(url,
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'ngrok-skip-browser-warning': '49654'
        },);
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete player');
    }
  }


}
