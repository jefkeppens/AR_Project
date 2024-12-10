import 'package:flutter/material.dart';
import '../models/player.dart';
import '../apis/player_api.dart';

const List<String> choices = <String>[
  'Save Player & Back',
  'Delete Player',
  'Back to List'
];

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

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id == 0) {
      player = Player(id: 0, name: "", optionIndex: 0);
    } else {
      _getPlayer(widget.id);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Player Homepage"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _menuSelected,
            itemBuilder: (BuildContext context) {
              return choices.asMap().entries.map((entry) {
                return PopupMenuItem<String>(
                  value: entry.key.toString(),
                  child: Text(entry.value),
                );
              }).toList();
            },
          ),
        ],
      ),
      
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
          const SizedBox(height: 20), // Add some space between the TextField and buttons
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
                  _confirmDelete();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Delete"),
                ),
              )
              
            ],
          ),
        ],
      ),
    );
  }
}


  void _menuSelected(String index) async {
    switch (index) {
      case "0": // Save User & Back
        _savePlayer();
        break;
      case "1": // Delete User
        _deletePlayer();
        break;
      case "2": // Back to List
        Navigator.pop(context, true);
        break;
      default:
    }
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

  void _confirmDelete() {
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
