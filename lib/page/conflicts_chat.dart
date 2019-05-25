import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/components/chat_message_list_item.dart';
import 'package:tutiflutti/scoped_model/main.dart';

var currentUserEmail;

class ConflictsChat extends StatefulWidget {
  @override
  ConflictsChatState createState() {
    return ConflictsChatState();
  }
}

class ConflictsChatState extends State<ConflictsChat> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isComposingMessage = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          appBar: AppBar(title: Text("Chat de conflictos")),
          body: Container(
              child: Column(children: <Widget>[
            _buildMessageList(model),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(model),
            ),
            Builder(builder: (BuildContext context) {
              return Container(width: 0.0, height: 0.0);
            })
          ])));
    });
  }

  Widget _buildMessageList(MainModel model) {
    return Flexible(
        child: FirebaseAnimatedList(
            query: model.getGameChat(),
            padding: const EdgeInsets.all(8.0),
            reverse: true,
            sort: (a, b) => b.key.compareTo(a.key),
            //comparing timestamp of messages to check which one would appear first
            itemBuilder:
                (context, DataSnapshot messageSnapshot, Animation<double> animation, int index) {
              return ChatMessageListItem(messageSnapshot, animation, model);
            }));
  }

  Widget _buildTextComposer(MainModel model) {
    return IconTheme(
        data: IconThemeData(
            color: _isComposingMessage
                ? Theme.of(context).accentColor
                : Theme.of(context).disabledColor),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () async {
//                        int timestamp = DateTime.now().millisecondsSinceEpoch;
//                      _sendMessage(messageText: null, imageUrl: downloadUrl.toString());
                      })),
              _buildMessageBox(model),
              _buildSendButton(model)
            ])));
  }

  Widget _buildMessageBox(MainModel model) {
    return Flexible(
        child: TextField(
      controller: _textEditingController,
      onChanged: (String messageText) {
        setState(() {
          _isComposingMessage = messageText.length > 0;
        });
      },
      onSubmitted: (text) {
        _textMessageSubmitted(model);
      },
      decoration: InputDecoration.collapsed(hintText: "Enviar mensaje"),
    ));
  }

  Widget _buildSendButton(MainModel model) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposingMessage ? () => _textMessageSubmitted(model) : null));
  }

  Future<Null> _textMessageSubmitted(MainModel model) async {
    String text = _textEditingController.text;
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    _sendMessage(message: text, imageUrl: null, model: model);
  }

  void _sendMessage({String message, String imageUrl, MainModel model}) {
    model.sendMessage(message, model.username);
  }
}
