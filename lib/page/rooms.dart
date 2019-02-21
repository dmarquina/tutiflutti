import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';

class RoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Salas de TutiFlutti'),
          ),
          body: Container(
              child: FirebaseAnimatedList(
                  query: model.getAllGames(),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    if (snapshot.value['status'] == Constants.GAME_STATUS_WAITING) {
                      return _buildRoomCard(model, snapshot, context);
                    } else {
                      return Container();
                    }
                  })),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                model.startGame(model.userId, model.userName);
                Navigator.pushReplacementNamed(context, Constants.WAITING_ROOM_PATH);
              },
              child: Icon(Icons.add)));
    });
  }

  Widget _buildRoomCard(MainModel model, DataSnapshot snapshot, BuildContext context) {
    return Container(
      child: InkWell(
        child: Card(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Text(snapshot.key)),
          elevation: 3.0,
        ),
        onTap: () {
          model.setGameId(snapshot.key);
          model.addUserGame(model.userId, model.userName);
          Navigator.pushReplacementNamed(context, Constants.WAITING_ROOM_PATH);
        },
      ),
    );
  }
}
