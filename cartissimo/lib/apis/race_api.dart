import 'package:cartissimo/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/race.dart';

class PlayerApi {
  static Future<List<Race>> fetchRaces() async {
    var url = Uri.https(globalServer, '/races');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((race) => Race.fromJson(race)).toList();
    } else {
      throw Exception('Failed to load races');
    }
  }

  static Future<Race> fetchRace(int id) async {
    var url = Uri.https(globalServer, '/races/$id');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Race.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load race');
    }
  }

    static Future<Race> createRace(Race race) async {
    var url = Uri.https(globalServer, '/races');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(race),
    );
    if (response.statusCode == 201) {
      return Race.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create race');
    }
  }

    static Future<Race> updateRace(int id, Race race) async {
    var url = Uri.https(globalServer, '/races/$id');

    final http.Response response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(race),
    );
    if (response.statusCode == 200) {
      return Race.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update race');
    }
  }

    static Future deleteRace(int id) async {
    var url = Uri.https(globalServer, '/races/$id');
    
    final http.Response response =
        await http.delete(url);
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete race');
    }
  }


}
