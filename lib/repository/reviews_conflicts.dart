import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tutiflutti/util/constants.dart';

class ReviewsConflictsRepository {
  DocumentReference gameReference;
  final databaseReference = Firestore.instance;

  ReviewsConflictsRepository(String gameId) {
    gameReference = databaseReference.collection('game').document(gameId);
  }

  insertNewConflicts(String category, String answer, String userId) async {
    DocumentSnapshot documentSnapshot =
        await gameReference.collection('conflicts').document(category + answer).get();
    if (documentSnapshot.exists) {
      Map<dynamic, dynamic> owners = documentSnapshot.data['owners'];
      owners[userId] = userId;
      await gameReference.collection('conflicts').document(category + answer).updateData({
        'category': documentSnapshot.data['category'],
        'answer': documentSnapshot.data['answer'],
        'owners': owners
      });
    } else {
      await gameReference.collection('conflicts').document(category + answer).setData({
        'category': category,
        'answer': answer,
        'owners': {userId: userId}
      });
    }
  }

  Future<void> setGoodAnswers(String category, String answer, String userId) async {
    DocumentSnapshot documentSnapshot =
        await gameReference.collection('goodAnswers').document(category + answer).get();
    if (!documentSnapshot.exists) {
      updateUserScoreAndInputsReviewed(userId, Constants.POINTS_FOR_GOOD_ANSWER, category);
      insertNewGoodAnswer(category, answer, userId);
    } else {
      if (documentSnapshot.data['category'] == category &&
          documentSnapshot.data['answer'] == answer) {
        if (documentSnapshot.data['originalOwner'] != null) {
          String userIdOwner = documentSnapshot.data['originalOwner'];
          updateUserScoreAndInputsReviewed(
              userIdOwner, Constants.NEGATIVE_POINTS_FOR_GOOD_REPEATED_ANSWER, category);
          updateUserScoreAndInputsReviewed(
              userId, Constants.POINTS_FOR_REPEATED_GOOD_ANSWER, category);
          updateGoodAnswerKeepingOriginalOwner(category, answer);
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
    DocumentSnapshot documentSnapshot = await gameReference.get();
    await gameReference.updateData({'reviewersLeft': documentSnapshot['reviewersLeft'] - 1});
  }

  subtractOneConflictReviewersLeft() async {
    DocumentSnapshot documentSnapshot = await gameReference.get();
    await gameReference
        .updateData({'conflictReviewersLeft': documentSnapshot['conflictReviewersLeft'] - 1});
  }

  Future<void> insertNewGoodAnswer(String category, String answer, String userId) async {
    await gameReference
        .collection('goodAnswers')
        .document(category + answer)
        .setData({'category': category, 'answer': answer, 'originalOwner': userId});
  }

  Future<void> updateGoodAnswerKeepingOriginalOwner(String category, String answer) async =>
      await gameReference
          .collection('goodAnswers')
          .document(category + answer)
          .updateData({'category': category, 'answer': answer});

  Future<Map<String, dynamic>> getConflicts() async {
    QuerySnapshot snapshot = await gameReference.collection('conflicts').getDocuments();
    Map<String, dynamic> conflicts = Map.fromIterable(snapshot.documents.map((d) => d.data));
//    conflicts
//        .removeWhere((k, v) => v['owners'][userToReviewId] != null || v['owners'][userId] != null);
    return conflicts;
  }

  Future<void> updateUserScoreAndInputsReviewed(String userId, int score, String category) async {
    DocumentSnapshot snapshot = await gameReference.collection('users').document(userId).get();
    int newScore = snapshot.data['score'] + score;

    if (score != Constants.NEGATIVE_POINTS_FOR_GOOD_REPEATED_ANSWER) {
      snapshot.data['inputsReviewed'] =
          checkInputsReviewed(snapshot.data['inputsReviewed'], score, category);
    }
    await gameReference.collection('users').document(userId).setData({
      'inputs': snapshot.data['inputs'],
      'reviewTo': snapshot.data['reviewTo'],
      'username': snapshot.data['username'],
      'score': newScore,
      'inputsReviewed': snapshot.data['inputsReviewed']
    });
  }

  dynamic checkInputsReviewed(dynamic inputsRev, int score, String category) {
    Map<dynamic, dynamic> inputsReviewed = inputsRev != null ? inputsRev : {};
    inputsReviewed[category] = 'green';
    return inputsReviewed;
  }

  addOneSupportConflict(String conflictId) async {
    DocumentSnapshot snapshot = await gameReference.collection('conflicts').document(conflictId).get();
    int newSupport = snapshot.data['support'] != null ? snapshot.data['support'] + 1 : 1;
    await gameReference.collection('conflicts').document(conflictId).updateData({
      'answer': snapshot.data['answer'],
      'category': snapshot.data['category'],
      'owners': snapshot.data['owners'],
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
    return gameReference.get().asStream().listen((event) {
      if (event.data == 0) {
        gameReference.child('conflicts').once().then((conflicts) async {
          await Future.forEach(Map.from(conflicts.value).values, (value) async {
            DataSnapshot ds = await gameReference
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
    return gameReference.child('conflictReviewersLeft').onValue.listen((Event event) {
      if (event.snapshot.value == 0) {
        gameReference.child('conflicts').once().then((conflicts) async {
          await Future.forEach(Map.from(conflicts.value).values, (value) async {
            DataSnapshot ds = await gameReference
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
