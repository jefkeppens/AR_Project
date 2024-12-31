import 'dart:convert';

import 'package:kartissimo/apis/game_api.dart';
import 'package:kartissimo/models/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:kartissimo/pages/player_detail.dart';
import 'package:kartissimo/services/unity_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kartissimo/models/player.dart';
import 'package:kartissimo/globals.dart';

class ArPageCustomizeCart extends StatefulWidget {
  final Player player;

  const ArPageCustomizeCart({super.key, required this.player});

  @override
  State<ArPageCustomizeCart> createState() => _ArPageCustomizeCartState();
}

class _ArPageCustomizeCartState extends State<ArPageCustomizeCart> {
  UnityWidgetController? _unityWidgetController;
  bool _isCameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermissions();
  }

  // Check for camera permission
  Future<void> _checkCameraPermissions() async {
    final status = await Permission.camera.request();

    if(status.isGranted) {
      setState(() {
        _isCameraPermissionGranted = true;
      });
    } else {
      setState(() {
        _isCameraPermissionGranted = false;
      });
    }
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraPermissionGranted) {
      return const Center(
          child: Text('Camera permission is required to proceed.'));
    }

    return UnityWidget(
      onUnityCreated: _onUnityCreated,
      onUnityMessage: onUnityMessage,
      onUnitySceneLoaded: onUnitySceneLoaded,
      useAndroidViewSurface: true,
      borderRadius: const BorderRadius.all(Radius.circular(70)),
    );
  }

  // Send chosen location to Unity!
  void _sendPlayerName() {
    _unityWidgetController?.postMessage('OpenScene', 'SetPlayerName', widget.player.name);
  }

  void _sendSceneName() {
    _unityWidgetController?.postMessage('OpenScene', 'LoadScene', 'CustomizeScene');
  }

  void _sendPlayerRecord() {
    List<Game> gameList = [];
    double minTime;
    GameApi.fetchGames().then((value) {
      setState(() {
        gameList = value.where((element) => element.playerId == widget.player.id).toList();
      });

      if (gameList.isNotEmpty) {
        minTime = gameList[0].beforeTime;
        for (Game game in gameList) {
          if (game.beforeTime < minTime) {
            minTime = game.beforeTime;
          }
        }
        _unityWidgetController?.postMessage('OpenScene', 'SetPlayerRecord', minTime.toString());
      } 
    });
  }

  void onUnityMessage(message) {
    bool success;
    String error = "";
    try {
      Map<String, dynamic> decodedMessage = json.decode(message);
      try {
        String key = decodedMessage['times'];
        List<double> newTimeList = [];
        if (key != "") {
          var timeList = key.split(",");
          for (String time in timeList) {
            int dotIndex = time.indexOf('.');
            if (dotIndex != -1 && dotIndex + 3 <= time.length) {
              time = time.substring(0, dotIndex + 3);
              newTimeList.add(double.parse(time));
            }
          }
          for (double time in newTimeList) {
            GameApi.createGame(Game(id: 0, beforeTime: time, playerId: widget.player.id));
          }
        }
        success = true;
      } catch(exc) {
        success = false;
        error = exc.toString();
      }
      

      if (success) {
        // Show dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Thanks for playing!"),
              content: const Text("Press OK to view your race times."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context, true);
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Show dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(error),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      // Handle the message as needed in your Flutter app
    } catch (e) {
      print('Error parsing message from Unity: $e');
    }
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    if (scene != null) {
      print('Received scene loaded from unity: ${scene.name}');
      print('Received scene loaded from unity buildIndex: ${scene.buildIndex}');
    } else {
      print('Received scene loaded from unity: null');
    }
  }

  // Callback that connects the created controller to the unity controller
  void _onUnityCreated(controller) {
    controller.resume();
    _unityWidgetController = controller;
    UnityService.setController(controller);
    _sendPlayerName();
    _sendPlayerRecord();
    _sendSceneName();
    unityInitiated = true;
  }
}
