import 'dart:ffi';
import 'dart:io';

import 'package:kartissimo/apis/game_api.dart';
import 'package:kartissimo/models/game.dart';
import 'package:kartissimo/pages/ar_page_customize_cart.dart';
import 'package:flutter/material.dart';
import 'package:kartissimo/services/unity_service.dart';
import '../models/player.dart';
import '../apis/player_api.dart';
import 'package:kartissimo/globals.dart';


class PlayerDetailPage extends StatefulWidget {
  final int id; // our UserDetailPage has an id-parameter which contains the id of the user to show

  // as always, use the key parameter and call the constructor of the super class
  // the id of the user to be shown is required
  const PlayerDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  Player? player;
  List<double> racingTimes = [];
  bool loading = true;

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id == 0) {
      player = Player(id: 0, name: "");
      loading = false;
    } else {
      _getPlayer(widget.id);
      _getGames();
      loading = true;
    }
  }

  void _getPlayer(int id) {
    PlayerApi.fetchPlayer(id).then((result) {
      // call the api to fetch the user data
      setState(() {
        player = result;
      });
      if (unityInitiated) {
        UnityService.sendPlayerName(player!.name);
        UnityService.sendPlayerRecord(player!);
      }
    });
  }

  void _getGames() async {
    setState(() {
      loading = true; // Set loading to true before starting fetch
    });

    try {
      final games = await GameApi.fetchGames(); // Await the API call

      setState(() {
        racingTimes = games
            .where((element) => element.playerId == widget.id)
            .map((e) => e.beforeTime)
            .toList();

        if (racingTimes.isNotEmpty) {
          racingTimes.sort(); // Sort racing times
          if (racingTimes.length > 15) {
            racingTimes = racingTimes.sublist(0, 15);
          }
        }

        loading = false; // Set loading to false after successful fetch
      });
    } catch (error) {
      // Log and handle error
      print("Error fetching games: $error");
      setState(() {
        loading = false; // Reset loading even if an error occurs
      });
    }
  }

  void _navigateToRacePage() async {
    // Navigate to the race page and wait for the result
    final shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArPageCustomizeCart(player: player!),
      ),
    );

    // Refresh data if the child page indicates an update
    if (shouldRefresh == true) {
      _getGames();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: _playerDetails(),
      ),
    );
  }


  _playerDetails() {
  if (player == null) {
    // Show a ProgressIndicator while the player is being loaded
    return const Center(child: CircularProgressIndicator());
  } else {
    TextStyle? textStyle = Theme.of(context).textTheme.bodyText1;

    nameController.text = player!.name; // Set the initial name in the TextField

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          // Add a button to go back at the top left
          Align(
            alignment: Alignment.topLeft,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous page
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text("Back"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Optional: change button color
              ),
            ),
          ),
          const SizedBox(height: 20), // Add spacing between the top button and the form
          TextField(
            controller: nameController,
            style: textStyle,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Name",
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          const SizedBox(height: 20), // Add space between the TextField and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: _savePlayer,
                  child: Text(player!.id == 0 ? "Add" : "Update"),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    _confirmDelete(player!.id);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text(player!.id == 0 ? "Cancel" : "Delete"),
                ),
              )
            ],
          ),
          if (widget.id != 0)
          const SizedBox(height: 20),
          if (widget.id != 0)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
            children: [
              // The button will now be aligned to the left
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToRacePage();
                  },
                  child: const Text("Start Racing"),
                ),
              ),
            ],
          ),
          if (widget.id != 0)
          const SizedBox(height: 20),
          // Add the styled list of racing times
          if (widget.id != 0)
          Text(
            "Top 15 Racing Times:",
            style: Theme.of(context).textTheme.headline6,
          ),
          if (widget.id != 0)
          const SizedBox(height: 10),
          Expanded(child: 
          ListView.builder(
            shrinkWrap: true, // Allows ListView to work inside a Column
            itemCount: racingTimes.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                title: Text(
                  "${racingTimes[index].toStringAsFixed(2)} seconds",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            },
          ),)
        ],
      ),
    );
  }
}


  void _savePlayer() {
    player!.name = nameController.text;

    if (player!.id == 0) {
      PlayerApi.createPlayer(player!);
    } else {
      PlayerApi.updatePlayer(widget.id, player!);
    }
  }

  void _deletePlayer() {
    PlayerApi.deletePlayer(widget.id).then((result) {
      Navigator.pop(context, true);
    });
  }

  void _confirmDelete(int id) {
    if (id == 0) {
      Navigator.pop(context, true);
    } else {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this player?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deletePlayer(); // Perform the deletion
              },
            ),
          ],
        );
      },
    );
    }
    
  }


}
