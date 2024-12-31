import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:kartissimo/apis/game_api.dart';
import 'package:kartissimo/models/game.dart';
import 'package:kartissimo/models/player.dart';

class UnityService {
  static UnityWidgetController? _unityWidgetController;

  static void setController(UnityWidgetController controller) {
    _unityWidgetController = controller;
  }

  static void sendPlayerName(String playerName) {
    _unityWidgetController?.postMessage('OpenScene', 'SetPlayerName', playerName);
  }

  static void sendPlayerRecord(Player player) {
    List<Game> gameList = [];
    double minTime;
    GameApi.fetchGames().then((value) => gameList = value);
    gameList = gameList.where((element) => element.playerId == player.id).toList();
    if (gameList.isNotEmpty) {
      minTime = gameList[0].beforeTime;
    for (Game game in gameList) {
      if (game.beforeTime < minTime) {
        minTime = game.beforeTime;
      }
    }
    _unityWidgetController?.postMessage('OpenScene', 'SetPlayerRecord', minTime);
    }
  }
  // Add other Unity-related methods as needed
}
