import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:tutiflutti/util/firebase_child_reference.dart';

class ChatRepository {
  final String _gameId;

  ChatRepository(this._gameId);

  final DatabaseReference gameDatabase = FirebaseReference.getReference('game');

  DatabaseReference getGameChat() => gameDatabase.child(_gameId).child('chat');

  Future<void> sendMessage(String message, String username) async {
    await gameDatabase
        .child(_gameId)
        .child('chat')
        .push()
        .set({'message': message, 'username': username});
  }

  Future<StreamSubscription<Event>> watchMessagesIncoming(Function addMessagesCount) async {
    return gameDatabase.child(_gameId).child('chat').onChildAdded.listen((Event event) {
      addMessagesCount();
    });
  }
}
