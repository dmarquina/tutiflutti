import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:tutiflutti/util/constants.dart';
import 'package:tutiflutti/util/firebase_child_reference.dart';

class ReviewsConflictsRepository {
  DatabaseReference gameDatabase;

  ReviewsConflictsRepository(String gameId) {
    gameDatabase = FirebaseReference.getReference('game').child(gameId);
  }

  insertNewConflicts(String category, String answer, String userId) async {
    DataSnapshot dataSnapshot =
        await gameDatabase.child('conflicts').child(category + answer).once();
    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> owners = dataSnapshot.value['owners'];
      owners[userId] = userId;
      await gameDatabase.child('conflicts').child(category + answer).update({
        'category': dataSnapshot.value['category'],
        'answer': dataSnapshot.value['answer'],
        'owners': owners
      });
    } else {
      await gameDatabase.child('conflicts').update({
        category + answer: {
          'category': category,
          'answer': answer,
          'owners': {userId: userId}
        }
      });
    }
  }

  Future<void> setGoodAnswers(String category, String answer, String userId) async {
    DataSnapshot dataSnapshot =
        await gameDatabase.child('goodAnswers').child(category + answer).once();
    if (dataSnapshot.value == null) {
      updateUserScoreAndInputsReviewed(userId, Constants.POINTS_FOR_GOOD_ANSWER, category);
      insertNewGoodAnswer(category, answer, userId);
    } else {
      if (dataSnapshot.value['category'] == category && dataSnapshot.value['answer'] == answer) {
        if (dataSnapshot.value['originalOwner'] != null) {
          String userIdOwner = dataSnapshot.value['originalOwner'];
          updateUserScoreAndInputsReviewed(
              userIdOwner, Constants.NEGATIVE_POINTS_FOR_GOOD_REPEATED_ANSWER, category);
          updateUserScoreAndInputsReviewed(
              userId, Constants.POINTS_FOR_REPEATED_GOOD_ANSWER, category);
          updateOwnerGoodAnswer(category, answer, userId);
        } else {
          updateUserScoreAndInputsReviewed(
              userId, Constants.POINTS_FOR_REPEATED_GOOD_ANSWER, category);
        }
      } else {
        insertNewGoodAnswer(category, answer, userId);
        updateUserScoreAndInputsReviewed(userId, Constants.POINTS_FOR_GOOD_ANSWER, category);
      }
    }
  }

  subtractOneReviewersLeft() async {
    DataSnapshot snapshot = await gameDatabase.child('reviewersLeft').once();
    await gameDatabase.update({'reviewersLeft': snapshot.value - 1});
  }

  subtractOneConflictReviewersLeft() async {
    DataSnapshot snapshot = await gameDatabase.child('conflictReviewersLeft').once();
    await gameDatabase.update({'conflictReviewersLeft': snapshot.value - 1});
  }

  Future<void> insertNewGoodAnswer(String category, String answer, String userId) async {
    await gameDatabase.child('goodAnswers').update({
      category + answer: {'category': category, 'answer': answer, 'originalOwner': userId}
    });
  }

  Future<void> updateOwnerGoodAnswer(String category, String answer, String userId) async =>
      await gameDatabase
          .child('goodAnswers')
          .child(category + answer)
          .set({'category': category, 'answer': answer});

  Future<Map<String, dynamic>> getConflicts() async {
    DataSnapshot snapshot = await gameDatabase.child('conflicts').once();
    Map<String, dynamic> conflicts = Map.from(snapshot.value);
//    conflicts
//        .removeWhere((k, v) => v['owners'][userToReviewId] != null || v['owners'][userId] != null);
    return conflicts;
  }

  Future<void> updateUserScoreAndInputsReviewed(String userId, int score, String category) async {
    DataSnapshot snapshot = await gameDatabase.child('users').child(userId).once();
    int newScore = snapshot.value['score'] + score;

    if (score != Constants.NEGATIVE_POINTS_FOR_GOOD_REPEATED_ANSWER) {
      snapshot.value['inputsReviewed'] =
          checkInputsReviewed(snapshot.value['inputsReviewed'], score, category);
    }

    await gameDatabase.child('users').child(userId).set({
      'inputs': snapshot.value['inputs'],
      'reviewTo': snapshot.value['reviewTo'],
      'username': snapshot.value['username'],
      'score': newScore,
      'inputsReviewed': snapshot.value['inputsReviewed']
    });
  }

  dynamic checkInputsReviewed(dynamic inputsRev, int score, String category) {
    Map<dynamic, dynamic> inputsReviewed = inputsRev != null ? inputsRev : {};
    inputsReviewed[category] = 'green';
    return inputsReviewed;
  }

  addOneSupportConflict(String conflictId) async {
    DataSnapshot snapshot = await gameDatabase.child('conflicts').child(conflictId).once();
    int newSupport = snapshot.value['support'] != null ? snapshot.value['support'] + 1 : 1;
    await gameDatabase.child('conflicts').child(conflictId).update({
      'answer': snapshot.value['answer'],
      'category': snapshot.value['category'],
      'owners': snapshot.value['owners'],
      'support': newSupport
    });
  }

  Map<String, String> getUserInputs(AsyncSnapshot snapshot) {
    Map<String, String> response = {};
    if (snapshot != null && snapshot.data != null) {
      if (snapshot.data?.value['inputs'] != null) {
        response = Map.from(snapshot.data?.value['inputs']);
      }
      if (snapshot.data?.value['noInput'] != null) {
        response = {};
      }
      if (snapshot.data?.value['inputs'] == null && snapshot.data?.value['noInput'] == null) {
        return null;
      }
    }

    return response;
  }

  Future<StreamSubscription<Event>> watchIfConflictIsOver(
      Function goToScore, String userId, int usersLength) async {
    return gameDatabase.child('conflictReviewersLeft').onValue.listen((Event event) {
      if (event.snapshot.value == 0) {
        gameDatabase.child('conflicts').once().then((conflicts) async {
          await Future.forEach(Map.from(conflicts.value).values, (value) async {
            DataSnapshot ds = await gameDatabase
                .child('goodAnswers')
                .child('${value['category']}${value['answer']}')
                .once();
            if (ds.value != null && value['owners'][userId] != null) {
              await this.setGoodAnswers(value['category'], value['answer'], userId);
            } else if (value['owners'][userId] != null &&
                value['support'] != null &&
                value['support'] > (usersLength / 2)) {
              await this.setGoodAnswers(value['category'], value['answer'], userId);
            }
          });
          goToScore();
        });
      }
    });
  }
}
