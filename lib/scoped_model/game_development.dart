import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/conflict.dart';

mixin GameDevelopmentModel on Model {
  Random _random = new Random();
  String gameId;
  String gameStatus = '';
  List<int> a = new List<int>.generate(25, (int index) => index + 65);
  List<Conflict> conflicts = [];

  final DatabaseReference gameDatabase = FirebaseDatabase.instance.reference().child('game');

  String getRandomAlphabetString() {
    int randomIndexWord = next(0, a.length);
    String gameWord = String.fromCharCode(a.elementAt(randomIndexWord));
    a.removeAt(randomIndexWord);
    return gameWord;
  }

  int next(int min, int max) => min + _random.nextInt(max - min);

  void setGameId(String gameId) {
    this.gameId = gameId;
  }

  String getGameId() => this.gameId;

  DatabaseReference getAllGames() {
    return gameDatabase;
  }

  DatabaseReference getAllGameUsers() {
    return gameDatabase.child(gameId).child('users');
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
    gameDatabase.child(gameId).child('users').child(userId).set({'username': username});
  }

  String getGameWord() {
    return gameDatabase.child(gameId).child('word').toString();
  }

  void updateGameWord(String word) {
    gameDatabase.child(gameId).update({'word': word});
  }

  void updateGameStatus(String status) {
    gameDatabase.child(gameId).update({'status': status});
  }

  Future<StreamSubscription<Event>> watchGameStatusInProgress(startGame) async {
    return gameDatabase.child(gameId).onValue.listen((Event event) {
      if (event.snapshot.value['status'] == 'inprogress') {
        startGame();
      }
    });
  }

  Future<StreamSubscription<Event>> watchGameStatusStop(stopEveryone) async {
    return gameDatabase.child(gameId).onValue.listen((Event event) {
      if (event.snapshot.value['status'] == 'stop') {
        stopEveryone();
      }
    });
  }
}
