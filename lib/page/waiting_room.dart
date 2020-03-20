import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/page/chat.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';
import 'package:tutiflutti/util/ui/rainbow_colors.dart';

class WaitingRoom extends StatefulWidget {
  final MainModel _model;
  final String title;

  WaitingRoom(this._model, {this.title});

  @override
  WaitingRoomState createState() => WaitingRoomState();
}

class WaitingRoomState extends State<WaitingRoom> {
  StreamSubscription _subscriptionGameStatus;
  StreamSubscription _subscriptionCanStartGame;
  bool _gameCanStart = false;
  bool _gameStarted = false;

  @override
  void initState() {
    widget._model
        .watchIfGameStatusInProgress(startGame)
        .then((StreamSubscription s) => _subscriptionGameStatus = s);
    widget._model
        .watchIfGameCanStart(toggleGameCanStart)
        .then((StreamSubscription s) => _subscriptionCanStartGame = s);
    widget._model.setReviewToUser(widget._model.userId, widget._model.username);

    super.initState();
  }

  @override
  void dispose() {
    _subscriptionGameStatus.cancel();
    _subscriptionCanStartGame.cancel();
    if (!_gameStarted) {
      widget._model.deleteUserFromGame(widget._model.userId);
    }

    super.dispose();
  }

  startGame() {
    _gameStarted = true;
    Navigator.pushReplacementNamed(context, Constants.START_GAME_PATH);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          appBar: AppBar(
              title: Text(widget.title.toUpperCase(), style: TextStyle(fontSize: 24)),
              backgroundColor: Colors.black87,
              elevation: 0.0,
              centerTitle: true,
              automaticallyImplyLeading: false),
          body: Container(
            color: Colors.black87,
            child: Column(children: <Widget>[
              Divider(color: Colors.white),
              Expanded(flex: 8, child: _buildUsersBoard()),
              Expanded(flex: 2, child: _buildLetsPlayButton(model))
            ]),
          ));
    });
  }

  Widget _buildUsersBoard() {
    return FirebaseAnimatedList(
        query: widget._model.getAllGameUsers(),
        itemBuilder:
            (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
          return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 25.0),
              child: Text(
                snapshot.value['username'],
                style: TextStyle(fontSize: 24.0, color: RainbowColors.rainbowColor(index)),
              ));
        });
  }

  Widget _buildLetsPlayButton(MainModel model) {
    return Column(
      children: <Widget>[
        Divider(color: Colors.white),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: FlatButton(
            onPressed:
                _gameCanStart ? () => model.startGame(Constants.GAME_STATUS_IN_PROGRESS) : null,
            child: Text(_gameCanStart ? '¡A JUGAR!' : 'ESPEREMOS',
                style:
                    TextStyle(color: _gameCanStart ? Colors.white : Colors.grey, fontSize: 20.0)),
          ),
        ),
      ],
    );
  }

  toggleGameCanStart(bool canStart) {
    _gameCanStart = canStart;
  }
}
