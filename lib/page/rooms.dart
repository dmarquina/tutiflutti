import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/page/waiting_room.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';
import 'package:tutiflutti/util/ui/rainbow_colors.dart';

class RoomsPage extends StatelessWidget {
  final _gameNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          appBar: Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoNavigationBar(middle: Text('Juegos disponibles'),automaticallyImplyLeading: false)
              : AppBar(title: Text('Juegos disponibles'), centerTitle: true,automaticallyImplyLeading: false),
          body: Container(
              child: FirebaseAnimatedList(
                  query: model.getAllGames(),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    if (snapshot.value['status'] == Constants.GAME_STATUS_WAITING) {
                      return _buildRoomCard(model, snapshot, context, index);
                    } else {
                      return Container();
                    }
                  })),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showInputGameNameDialog(context, model);
              },
              child: Icon(Icons.add)));
    });
  }

  _showInputGameNameDialog(BuildContext context, MainModel model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoAlertDialog(
                  title: Text('Nombre del juego'),
                  content: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: CupertinoTextField(controller: _gameNameController, maxLength: 25)),
                  actions: <Widget>[
                      CupertinoDialogAction(
                          child: Text('Cancelar'),
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      CupertinoDialogAction(
                          child: Text('Guardar'),
                          isDefaultAction: true,
                          onPressed: () {
                            model.createGame(
                                _gameNameController.text, model.userId, model.username);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WaitingRoom(model, title: _gameNameController.text)));
                          })
                    ])
              : AlertDialog(
                  title: Text('Nombre del juego'),
                  content: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: _gameNameController,
                        maxLength: 25,
                      )),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        Navigator.pop(context);
                      }
                    ),
                    FlatButton(
                      child: Text('Guardar'),
                      onPressed: () {
                        model.createGame(_gameNameController.text, model.userId, model.username);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WaitingRoom(model, title: _gameNameController.text)));
                      }
                    )
                  ]
                );
        });
  }

  Widget _buildRoomCard(MainModel model, DataSnapshot snapshot, BuildContext context, int index) {
    Map<String, dynamic> admin = Map<String, dynamic>.from(snapshot.value['administrator']);
    return Container(
      child: InkWell(
        child: Card(
          color: RainbowColors.rainbowColor(index),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(children: <Widget>[
                Text(
                  '${snapshot.value['name']}',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                SizedBox(height: 10.0),
                Text('Creado por ${admin.values.first['username'].toString()}',
                    style: TextStyle(fontSize: 10.0, color: Colors.white)),
              ])),
          elevation: 3.0,
        ),
        onTap: () {
          model.setGameId(snapshot.key);
          model.addUserGame(model.userId, model.username);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WaitingRoom(model, title: snapshot.value['name'].toString())));
        },
      ),
    );
  }
}
