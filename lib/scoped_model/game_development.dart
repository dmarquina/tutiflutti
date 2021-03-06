import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/util/constants.dart';
import 'package:tutiflutti/util/firebase_child_reference.dart';
import 'package:tutiflutti/util/random_letter.dart';

mixin GameDevelopmentModel on Model {
  String _gameId;
  String _gameLetter = '';
  String _userToReviewId = '';
  int _usersLength = 0;

  final DatabaseReference gameDatabase = FirebaseReference.getReference('game');

  setGameId(String gameId) => this._gameId = gameId;

  String get gameId => this._gameId;

  setGameLetter(String gameLetter) => this._gameLetter = gameLetter;

  String get gameLetter => this._gameLetter;

  setUserToReviewId(String userToReviewId) => this._userToReviewId = userToReviewId;

  String get userToReviewId => this._userToReviewId;

  setUsersLength(int _usersLength) => this._usersLength = _usersLength;

  int get usersLength => this._usersLength;

  DatabaseReference getAllGames() => gameDatabase;

  DatabaseReference getAllGameUsers() => gameDatabase.child(_gameId).child('users');



  Future<Map<String, String>> getUserAdministrator(String gameId) async {
    DataSnapshot administrator = await gameDatabase.child(gameId).child('administrator').once();
    Map<String, dynamic> admin = Map<String, dynamic>.from(administrator.value);
    return {admin.keys.first: admin.values.first['username'].toString()};
  }

  createGame(String gameName, String userId, String username) {
    DatabaseReference newGame = gameDatabase.push();
    newGame.set({
      'name': gameName,
      'administrator': {
        userId: {'username': username}
      },
      'status': Constants.GAME_STATUS_WAITING,
      'letter': Constants.EMPTY_CHARACTER,
      'chat': Constants.EMPTY_CHARACTER,
      'missing_letters': Constants.calcInitialMissingLettersList(),
      'users': {
        userId: {'username': username, 'score': 0}
      },
    });
    this.setGameId(newGame.key);
    this.updateGameLetter();
  }

  startGame(String status) async {
    DataSnapshot snapshot = await this.getUsersLength();
    this.setReviewersLeft(snapshot.value.length);
    this.setConflictReviewersLeft(snapshot.value.length);
    Map<String, String> admin = await getUserAdministrator(_gameId);
    await this.setReviewToUser(admin.keys.first, admin.values.first);
    await this.updateGameStatus(status);
  }

  getUsersLength() {
    return getAllGameUsers().once();
  }

  addUserGame(String userId, String username) => gameDatabase
      .child(_gameId)
      .child('users')
      .child(userId)
      .set({'username': username, 'score': 0});

  deleteUserFromGame(String userId) =>
      gameDatabase.child(_gameId).child('users').child(userId).remove();

  updateGameLetter() async {
    DataSnapshot missingLetters = await gameDatabase.child(_gameId).child('missing_letters').once();
    Map<String, List<int>> randomLetter =
        RandomLetter.getRandomLetter(List<int>.from(missingLetters.value));
    await gameDatabase.child(_gameId).update({'letter': randomLetter.keys.first});
    await gameDatabase.child(_gameId).update({'missing_letters': randomLetter.values.first});
  }

  updateGameStatus(String status) => gameDatabase.child(_gameId).update({'status': status});

  setReviewersLeft(int reviewersLeft) =>
      gameDatabase.child(_gameId).update({'reviewersLeft': reviewersLeft});

  setConflictReviewersLeft(int conflictReviewersLeft) =>
      gameDatabase.child(_gameId).update({'conflictReviewersLeft': conflictReviewersLeft});

  getGameLetterFirebase() async {
    DataSnapshot letter = await gameDatabase.child(_gameId).child('letter').once();
    this.setGameLetter(letter.value);
    notifyListeners();
  }

  // El usuario no puede agregarse asimismo y buscamos añadir un reviewTo solo al que lo necesita
  setReviewToUser(String userId, String username) async {
    DataSnapshot gameUsers = await getAllGameUsers().once();
    for (MapEntry<String, dynamic> user in Map<String, dynamic>.from(gameUsers.value).entries) {
      if (user.key != userId && user.value['reviewTo'] == null) {
        gameDatabase.child(_gameId).child('users').child(user.key).update({
          'reviewTo': {
            userId: {'username': username}
          }
        });
        break;
      }
    }
  }

  getUserToReview(String userId) async {
    DataSnapshot dataSnapshot =
        await gameDatabase.child(_gameId).child('users').child(userId).child('reviewTo').once();
    Map<String, dynamic> reviewTo = Map<String, dynamic>.from(dataSnapshot.value);
    this.setUserToReviewId(reviewTo.keys.first);
  }

  Stream getUserInfo(String userId) =>
      Stream.fromFuture(gameDatabase.child(_gameId).child('users').child(userId).once());

  saveUserInputs(String userId, Map<String, String> inputs) {
    if (inputs.isNotEmpty) {
      gameDatabase.child(_gameId).child('users').child(userId).child('inputs').set(inputs);
    } else {
      gameDatabase.child(_gameId).child('users').child(userId).child('noInput').set('noInput');
    }
  }

  Stream<DataSnapshot> getScoreBoard() =>
      Stream.fromFuture(gameDatabase.child(_gameId).child('users').once());

  Future<StreamSubscription<Event>> watchIfGameCanStart(toggleGameCanStart) async {
    return gameDatabase.child(_gameId).child('users').onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        Map.from(event.snapshot.value).length > 1
            ? toggleGameCanStart(true)
            : toggleGameCanStart(false);
      } else {
        toggleGameCanStart(false);
      }
      notifyListeners();
    });
  }

  Future<StreamSubscription<Event>> watchIfGameStatusInProgress(startGame) async {
    return gameDatabase.child(_gameId).onValue.listen((Event event) async {
      if (event.snapshot.value['status'] == Constants.GAME_STATUS_IN_PROGRESS) {
        startGame();
        DataSnapshot snapshot = await this.getUsersLength();
        this.setUsersLength(snapshot.value.length);
      }
    });
  }

  Future<StreamSubscription<Event>> watchIfInputsIsOver(Function goToReview, String userId) async {
    DataSnapshot snapshot = await gameDatabase.child(_gameId).child('users').child(userId).once();
    Map<String, dynamic> res = Map.from(snapshot.value['reviewTo']);
    return gameDatabase
        .child(_gameId)
        .child('users')
        .child(res.keys.first)
        .onValue
        .listen((Event event) {
      if (event.snapshot.value['inputs'] != null || event.snapshot.value['noInput'] != null) {
        goToReview();
      }
    });
  }

  Future<StreamSubscription<Event>> watchIfReviewIsOver(
      Function goConflicts, Function goToScore) async {
    return gameDatabase.child(_gameId).child('reviewersLeft').onValue.listen((Event event) {
      if (event.snapshot.value == 0) {
        gameDatabase.child(_gameId).child('conflicts').once().then((conflicts) {
          if (conflicts.value == null) {
            goToScore();
          } else {
            goConflicts();
          }
        });
      }
    });
  }

  Future<StreamSubscription<Event>> watchIfGameStatusStop(String userId, stopEveryone) async {
    return gameDatabase.child(_gameId).onValue.listen((Event event) {
      if (event.snapshot.value['status'] == Constants.GAME_STATUS_STOP) {
        this.getUserToReview(userId);
        stopEveryone();
      }
    });
  }


}
