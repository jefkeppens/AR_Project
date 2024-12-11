import 'dart:convert';

import 'package:cartissimo/apis/player_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cartissimo/globals.dart';
import 'package:cartissimo/models/player.dart';

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
  void _sendIndex() {
    _unityWidgetController?.postMessage('CartInput', 'SetPlayerCart', 
    jsonEncode(widget.player.optionIndex));
  }

  // // Send username to Unity!
  // void _sendPlayerName() {
  //   _unityWidgetController?.postMessage('TargetLocation', 'SetPlayerName', globalPlayerName);
  // }

  void _sendSceneName() {
    _unityWidgetController?.postMessage('OpenScene', 'LoadScene', 'CustomizeScene');
  }

  void onUnityMessage(message) {
    try {
      Map<String, dynamic> decodedMessage = json.decode(message);
      int key = int.parse(decodedMessage['key']);
      Player updatedPlayer = Player(name: 'name', id: 0, optionIndex: 0);
      PlayerApi.fetchPlayer(widget.player.id).then((value) => updatedPlayer = value);
      updatedPlayer.optionIndex = key;
      updatedPlayer.name = widget.player.name;
      PlayerApi.updatePlayer(widget.player.id, updatedPlayer);

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
    _sendIndex();
    // _sendPlayerName();
    _sendSceneName();
  }
}
