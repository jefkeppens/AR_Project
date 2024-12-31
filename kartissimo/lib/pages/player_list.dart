import 'package:kartissimo/globals.dart';
import 'package:kartissimo/pages/player_detail.dart';
import 'package:flutter/material.dart';
import '../models/player.dart';
import '../apis/player_api.dart';

class PlayerListPage extends StatefulWidget {
  const PlayerListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State {
  List<Player> playerList = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    _getPlayers();
  }

  void _getPlayers() {
    PlayerApi.fetchPlayers().then((result) {
      setState(() {
        playerList = result;
        count = result.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick a player or create one in the bottom right"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToDetail(0);
        },
        tooltip: "Add new User",
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: _userListItems(),
      ),
    );
  }

  ListView _userListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Text(playerList[position].name.substring(0, 1)),
            ),
            title: Text(playerList[position].name),
            onTap: () {
              _navigateToDetail(playerList[position].id);
            },
          ),
        );
      },
    );
  }

  void _navigateToDetail(int id) async {
    if (id != 0) {
      PlayerApi.fetchPlayer(id).then((result) {
      // call the api to fetch the user data
      setState(() {
        globalPlayerName = result.name;
      });
    });
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayerDetailPage(id: id)),
    );
    
    _getPlayers();
  }
}

