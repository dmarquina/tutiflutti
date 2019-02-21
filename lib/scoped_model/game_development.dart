import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/conflict.dart';
import 'package:tutiflutti/util/constants.dart';
import 'package:tutiflutti/util/firebase_child_reference.dart';

mixin GameDevelopmentModel on Model {
  String _gameId;
  List<Conflict> conflicts = [];

  final DatabaseReference gameDatabase = FirebaseReference.getReference('game');

  void setGameId(String gameId) {
    this._gameId = gameId;
  }

  String getGameId() => this._gameId;

  DatabaseReference getAllGames() {
    return gameDatabase;
  }

  DatabaseReference getAllGameUsers() {
    return gameDatabase.child(_gameId).child('users');
  }

  void startGame(String userId, String username) {
    DatabaseReference newGame = gameDatabase.push();
    newGame.set({
      'status': 'waiting',
      'word': '',
      'users': {
        userId: {'username': username}
      }
    });
    this.setGameId(newGame.key);
  }

  void addUserGame(String userId, String username) {
    gameDatabase.child(_gameId).child('users').child(userId).set({'username': username});
  }

  String getGameWord() {
    return gameDatabase.child(_gameId).child('word').toString();
  }

  void updateGameWord(String word) {
    gameDatabase.child(_gameId).update({'word': word});
  }

  void updateGameStatus(String status) {
    gameDatabase.child(_gameId).update({'status': status});
  }

  Future<StreamSubscription<Event>> watchIfGameStatusInProgress(startGame) async {
    return gameDatabase.child(_gameId).onValue.listen((Event event) {
      if (event.snapshot.value['status'] == Constants.GAME_STATUS_IN_PROGRESS) {
        startGame();
      }
    });
  }

  Future<StreamSubscription<Event>> watchIfGameStatusStop(stopEveryone) async {
    return gameDatabase.child(_gameId).onValue.listen((Event event) {
      if (event.snapshot.value['status'] == Constants.GAME_STATUS_STOP) {
        stopEveryone();
      }
    });
  }
}
