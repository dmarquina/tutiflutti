import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/page/chat.dart';
import 'package:tutiflutti/page/wait_score.dart';
import 'package:tutiflutti/repository/chat.dart';
import 'package:tutiflutti/repository/reviews_conflicts.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';

class ConflictsPage extends StatefulWidget {
  final MainModel model;

  ConflictsPage(this.model);

  @override
  _ConflictsPageState createState() => _ConflictsPageState();
}

class _ConflictsPageState extends State<ConflictsPage> {
  StreamSubscription _subscriptionNewMessages;
  ReviewsConflictsRepository reviewsConflictsRepository;
  ChatRepository chatRepository;
  Map<String, dynamic> _conflicts;

  @override
  void initState() {
    reviewsConflictsRepository = ReviewsConflictsRepository(widget.model.gameId);

    reviewsConflictsRepository.getConflicts().then((conflicts) {
      setState(() {
        _conflicts = conflicts;
      });
    });
    chatRepository = ChatRepository(widget.model.gameId);
    chatRepository
        .watchMessagesIncoming(addMessagesCount)
        .then((StreamSubscription s) => _subscriptionNewMessages = s);
    super.initState();
  }

  @override
  void dispose() {
    widget.model.resetIncomingMessages();
    _subscriptionNewMessages.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      model = widget.model;
      return Scaffold(
          appBar: AppBar(
              title: Text('Conflictos'),
              actions: <Widget>[
                Stack(children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.message),
                      color: Colors.white,
                      onPressed: () {
                        model.resetIncomingMessages();
                        model.stopWatchIncomingMessages();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
                      }),
                  model.newIncomingMessages > 0
                      ? _buildMessageCounter(model.newIncomingMessages)
                      : Container()
                ])
              ],
              automaticallyImplyLeading: false),
          body: Container(
              child: Center(
                  child: Column(children: <Widget>[
            SizedBox(height: 20.0),
            Text(model.gameLetter, style: TextStyle(fontSize: 56.0)),
            SizedBox(height: 20.0),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text('¿Estas palabras son correctas?', textAlign: TextAlign.center)),
            SizedBox(height: 20.0),
            _buildLegend(),
            SizedBox(height: 10.0),
            Divider(height: 0.0),
            fetchAnswers()
          ]))));
    });
  }

  Widget _buildMessageCounter(int newMessages) {
    String messageCounter = newMessages > 9 ? '9+' : '${newMessages.toString()}';
    return Positioned(
      width: 18,
      height: 18,
      top: 5,
      left: 25,
      child: CircleAvatar(
          backgroundColor: Colors.redAccent,
          child: Text(messageCounter, style: TextStyle(color: Colors.white, fontSize: 10))),
    );
  }

  Widget fetchAnswers() {
    if (_conflicts == null) {
      return Center(
          child: Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoActivityIndicator()
              : CircularProgressIndicator());
    } else {
      if (_conflicts.isEmpty) {
        return Center(
            child: Column(children: <Widget>[
          SizedBox(height: 50.0),
          Text('No hay conflictos por revisar'),
          SizedBox(height: 10.0),
          RaisedButton(
              child: Text('Continuar', style: TextStyle(color: Colors.white)),
              color: Colors.teal,
              onPressed: () {
                reviewsConflictsRepository.subtractOneConflictReviewersLeft();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => WaitScorePage(widget.model)));
              })
        ]));
      } else {
        return _buildConflictsInputs();
      }
    }
  }

  Widget _buildConflictsInputs() {
    return Flexible(
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              String conflictKey = _conflicts.keys.elementAt(index);
              return Dismissible(
                  key: Key(conflictKey),
                  direction: DismissDirection.horizontal,
                  onDismissed: (DismissDirection direction) {
                    if (direction == DismissDirection.startToEnd) {
                      reviewsConflictsRepository.addOneSupportConflict(conflictKey);
                    }
                    _conflicts.remove(conflictKey);
                    if (_conflicts.isEmpty) {
                      reviewsConflictsRepository.subtractOneConflictReviewersLeft();
                      Navigator.pushReplacementNamed(context, Constants.WAIT_SCORE_PATH);
                    }
                  },
                  background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(Icons.check, color: Colors.white, size: 30.0)),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.clear, color: Colors.white, size: 30.0),
                  ),
                  child: Column(children: <Widget>[
                    ListTile(
                        title: Text(_conflicts[conflictKey]['category']),
                        subtitle: Text(_conflicts[conflictKey]['answer'])),
                    Divider(height: 2.0)
                  ]));
            },
            itemCount: _conflicts.length));
  }

  Widget _buildLegend() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Row(children: <Widget>[
            Icon(Icons.arrow_back, color: Colors.red),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Text('Incorrecto', style: TextStyle(color: Colors.red)))
          ]),
          Row(children: <Widget>[
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Text('Correcto', style: TextStyle(color: Colors.green))),
            Icon(Icons.arrow_forward, color: Colors.green)
          ])
        ]));
  }

  addMessagesCount() {
    widget.model.addOneIncomingMessage();
  }
}
