import 'package:cartissimo/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/game.dart';

class GameApi {
  static Future<List<Game>> fetchGames() async {
    var url = Uri.https(globalServer, '/games');

    final response = await http.get(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '49654'
      },);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((game) => Game.fromJson(game)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  static Future<Game> fetchGame(int id) async {
    var url = Uri.https(globalServer, '/games/$id');

    final response = await http.get(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '49654'
      },);
    if (response.statusCode == 200) {
      return Game.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load game');
    }
  }

    static Future<Game> createGame(Game game) async {
    var url = Uri.https(globalServer, '/games');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '49654'
      },
      body: jsonEncode(game),
    );
    if (response.statusCode == 201) {
      return Game.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create game');
    }
  }

    static Future<Game> updateGame(int id, Game game) async {
    var url = Uri.https(globalServer, '/games/$id');

    final http.Response response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '49654'
      },
      body: jsonEncode(game),
    );
    if (response.statusCode == 200) {
      return Game.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update game');
    }
  }

    static Future deleteGame(int id) async {
    var url = Uri.https(globalServer, '/games/$id');
    
    final http.Response response =
        await http.delete(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'ngrok-skip-browser-warning': '49654'
        },);
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete game');
    }
  }


}
