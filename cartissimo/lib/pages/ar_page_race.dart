import 'dart:convert';

import 'package:cartissimo/models/race.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:cartissimo/globals.dart';

class ArPageRace extends StatefulWidget {
  final Race race;

  const ArPageRace({super.key, required this.race});

  @override
  State<ArPageRace> createState() => _ArPageRaceState();
}

class _ArPageRaceState extends State<ArPageRace> {
  UnityWidgetController? _unityWidgetController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return UnityWidget(
      onUnityCreated: _onUnityCreated,
      onUnityMessage: onUnityMessage,
      onUnitySceneLoaded: onUnitySceneLoaded,
      useAndroidViewSurface: true,
      borderRadius: const BorderRadius.all(Radius.circular(70)),
    );
  }

  // Send chosen location to Unity!
  void _sendRaceIndex() {
    _unityWidgetController?.postMessage('TargetLocation', 'SetRace', 
    jsonEncode(widget.race.toJson()));
  }

  // Send username to Unity!
  void _sendPlayerName() {
    _unityWidgetController?.postMessage('TargetLocation', 'SetPlayerName', globalPlayerName);
  }

  void _sendSceneName() {
    _unityWidgetController?.postMessage('TargetLocation', 'SetSceneName', 'RacingScene');
  }

  void onUnityMessage(message) {
    try {
      Map<String, dynamic> decodedMessage = json.decode(message);
      String key = decodedMessage['key'];
      bool success = decodedMessage['success'];

      if (success) {
        // Show dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Finished succesfully!"),
              content: const Text("You have chosen your cart style."),
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
    _sendRaceIndex();
    _sendPlayerName();
    _sendSceneName();
  }
}
