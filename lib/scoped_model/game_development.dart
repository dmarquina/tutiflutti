import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/conflict.dart';
import 'package:tutiflutti/util/constants.dart';
import 'package:tutiflutti/util/firebase_child_reference.dart';
import 'package:tutiflutti/util/random_letter.dart';

mixin GameDevelopmentModel on Model {
  String _gameId;
  String _gameLetter = '';
  String _userToReviewId = '';
  bool showProgressIndicator = true;
  List<Conflict> conflicts = [];

  final DatabaseReference gameDatabase = FirebaseReference.getReference('game');

  setGameId(String gameId) => this._gameId = gameId;

  String get gameId => this._gameId;

  setGameLetter(String gameLetter) => this._gameLetter = gameLetter;

  String get gameLetter => this._gameLetter;

  setUserToReviewId(String userToReviewId) => this._userToReviewId = userToReviewId;

  String get userToReviewId => this._userToReviewId;

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
      'missing_letters': new List<int>.generate(25, (int index) => index + 65),
      'users': {
        userId: {'username': username, 'score': 0}
      },
    });
    this.setGameId(newGame.key);
    this.updateGameLetter();
  }

  startGame(String status) async {
    Map<String, String> admin = await getUserAdministrator(_gameId);
    await this.setReviewToUser(admin.keys.first, admin.values.first);
    await this.updateGameStatus(status);
  }

  addUserGame(String userId, String username) => gameDatabase
      .child(_gameId)
      .child('users')
      .child(userId)
      .set({'username': username, 'score': 0});

  updateGameLetter() async {
    DataSnapshot missingLetters = await gameDatabase.child(_gameId).child('missing_letters').once();
    Map<String, List<int>> randomLetter =
        RandomLetter.getRandomLetter(List<int>.from(missingLetters.value));
    await gameDatabase.child(_gameId).update({'letter': randomLetter.keys.first});
    await gameDatabase.child(_gameId).update({'missing_letters': randomLetter.values.first});
  }

  updateGameStatus(String status) => gameDatabase.child(_gameId).update({'status': status});

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
    print(reviewTo.keys.first);
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

  insertNewConflicts(String category, String answer, String userId) async {
    await gameDatabase.child(_gameId).child('conflicts').update({
      category + answer + userId: {'category': category, 'answer': answer, 'owner': userId}
    });
  }

  setGoodAnswers(String category, String answer, String userId) async {
    DataSnapshot dataSnapshot =
        await gameDatabase.child(_gameId).child('goodAnswers').child(category + answer).once();
    if (dataSnapshot.value == null) {
      updateUserScore(userId, 100);
      await insertNewGoodAnswer(category, answer, userId);
    } else {
      if (dataSnapshot.value['category'] == category && dataSnapshot.value['answer'] == answer) {
        if (dataSnapshot.value['originalOwner'] != null) {
          String userIdOwner = dataSnapshot.value['originalOwner'];
          updateUserScore(userIdOwner, -50);
          updateUserScore(userId, 50);
          await updateOwnerGoodAnswer(category, answer, userId);
        } else {
          updateUserScore(userId, 50);
        }
      } else {
        updateUserScore(userId, 100);
        await insertNewGoodAnswer(category, answer, userId);
      }
    }
  }

  Future<void> insertNewGoodAnswer(String category, String answer, String userId) {
    return gameDatabase.child(_gameId).child('goodAnswers').update({
      category + answer: {'category': category, 'answer': answer, 'originalOwner': userId}
    });
  }

  Future<void> updateOwnerGoodAnswer(String category, String answer, String userId) {
    return gameDatabase
        .child(_gameId)
        .child('goodAnswers')
        .child(category + answer)
        .set({'category': category, 'answer': answer});
  }

  updateUserScore(String userId, int score) async {
    DataSnapshot snapshot = await gameDatabase.child(_gameId).child('users').child(userId).once();
    int newScore = snapshot.value['score'] + score;
    await gameDatabase.child(_gameId).child('users').child(userId).set({
      'inputs': snapshot.value['inputs'],
      'reviewTo': snapshot.value['reviewTo'],
      'username': snapshot.value['username'],
      'score': newScore
    });
  }

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

  Map<String, String> getUserInputsToMap(AsyncSnapshot snapshot) {
    Map<String, String> response = {};
    if (snapshot.data.value['inputs'] != null) {
      response = Map.from(snapshot.data.value['inputs']);
    }
    if (snapshot.data.value['noInput'] != null) {
      response = {};
    }
    if (snapshot.data.value['inputs'] == null && snapshot.data.value['noInput'] == null) {
      return null;
    }

    return response;
  }

  Future<StreamSubscription<Event>> watchIfGameStatusInProgress(startGame) async {
    return gameDatabase.child(_gameId).onValue.listen((Event event) {
      if (event.snapshot.value['status'] == Constants.GAME_STATUS_IN_PROGRESS) {
        startGame();
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
