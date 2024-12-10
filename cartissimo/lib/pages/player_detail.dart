import 'package:cartissimo/models/race.dart';
import 'package:cartissimo/pages/ar_page_customize_cart.dart';
import 'package:cartissimo/pages/ar_page_race.dart';
import 'package:flutter/material.dart';
import '../models/player.dart';
import '../apis/player_api.dart';
import '../apis/race_api.dart';


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
  List<Race> races = [];

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id == 0) {
      player = Player(id: 0, name: "", optionIndex: 0);
    } else {
      _getPlayer(widget.id);
      _getRaces();
    }
  }

  void _getPlayer(int id) {
    PlayerApi.fetchPlayer(id).then((result) {
      // call the api to fetch the user data
      setState(() {
        player = result;
      });
    });
  }

  void _getRaces() {
    RaceApi.fetchRaces().then((value) => races = value);
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
                  child: Text(player!.id == 0? "Cancel": "Delete"),
                ),
              )
            ],
          ),
          const SizedBox(height: 20), 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,  // Align children to the left
            children: [
              // The button will now be aligned to the left
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArPageCustomizeCart(player: player!)),
                    );
                  },
                  child: const Text("Customize Cart"),
                ),
              ),
              
              const SizedBox(height: 20), // Add space between button and ListView

              // The ListView will be below the button
              Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  shrinkWrap: true, // Ensures ListView only takes as much space as needed
                  physics: const NeverScrollableScrollPhysics(), // Disables independent scrolling of the ListView
                  itemCount: races.length,
                  itemBuilder: (context, index) {
                    final race = races[index];
                    return ListTile(
                      title: Text(race.name),
                      subtitle: Text(
                        "Difficulty: ${race.difficulty.name}, Distance: ${race.distance}m, Time Limit: ${race.beforeTimeLimit} minutes",
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Perform action when race is selected
                          _selectRace(context, race);
                        },
                        child: const Text("Select"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),



        ],
      ),
    );
  }
  }

  void _selectRace(BuildContext context, Race race) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArPageRace(race: race)),
    );
  }

  void _savePlayer() {
    player!.name = nameController.text;

    if (player!.id == 0) {
      PlayerApi.createPlayer(player!).then((result) {
        Navigator.pop(context, true);
      });
    } else {
      PlayerApi.updatePlayer(widget.id, player!).then((result) {
        Navigator.pop(context, true);
      });
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
