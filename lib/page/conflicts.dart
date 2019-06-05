import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutiflutti/page/conflicts_chat.dart';
import 'package:tutiflutti/page/wait_score.dart';
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
  int newMessagesCount = 0;

  @override
  void initState() {
    widget.model
        .watchMessagesIncoming(addMessagesCount)
        .then((StreamSubscription s) => _subscriptionNewMessages = s);
    super.initState();
  }

  @override
  void dispose() {
    _subscriptionNewMessages.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Conflictos'),
            actions: <Widget>[
              Stack(children: <Widget>[
                IconButton(
                    icon: Icon(Icons.message),
                    color: Colors.white,
                    onPressed: () {
                      newMessagesCount = 0;

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConflictsChat(resetNewMessagesCount)));
                    }),
                newMessagesCount > 0 ? _buildMessageCounter(newMessagesCount) : Container()
              ])
            ],
            automaticallyImplyLeading: false),
        body: Container(
            child: Center(
                child: Column(children: <Widget>[
          SizedBox(height: 20.0),
          Text(widget.model.gameLetter, style: TextStyle(fontSize: 56.0)),
          SizedBox(height: 20.0),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text('¿Estas palabras son correctas?', textAlign: TextAlign.center)),
          SizedBox(height: 20.0),
          _buildLegend(),
          SizedBox(height: 10.0),
          Divider(height: 0.0),
          fetchAnswers(widget.model)
        ]))));
  }

  resetNewMessagesCount() {
    setState(() {
      newMessagesCount = 0;
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

  Widget fetchAnswers(MainModel model) {
    return StreamBuilder(
        stream: model.getConflicts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> conflicts = model.getConflictsInputs(snapshot, model.userId);
            int _itemCount = conflicts.length;
            if (_itemCount == 0) {
              return Center(
                  child: Column(children: <Widget>[
                SizedBox(height: 50.0),
                Text('No hay conflictos por revisar'),
                SizedBox(height: 10.0),
                RaisedButton(
                    child: Text('Continuar', style: TextStyle(color: Colors.white)),
                    color: Colors.teal,
                    onPressed: () {
                      model.subtractOneConflictReviewersLeft();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => WaitScorePage(model)));
                    })
              ]));
            }
            List conflictsList = conflicts.keys.toList();
            return Flexible(
                child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      String key =
                          '${conflicts[conflictsList[index]]['category']}${conflicts[conflictsList[index]]['answer']}${conflicts[conflictsList[index]]['owner']}';
                      return Dismissible(
                          key: Key(key),
                          direction: DismissDirection.horizontal,
                          onDismissed: (DismissDirection direction) {
                            if (direction == DismissDirection.startToEnd) {
                              model.addOneSupportConflict(key);
                            }
                            _itemCount--;
                            if (_itemCount == 0) {
                              model.subtractOneConflictReviewersLeft();
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
                                title: Text(conflicts[conflictsList[index]]['category']),
                                subtitle: Text(conflicts[conflictsList[index]]['answer'])),
                            Divider(height: 2.0)
                          ]));
                    },
                    itemCount: _itemCount));
          } else {
            return Center(
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator());
          }
        });
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
    setState(() {
      newMessagesCount++;
    });
  }
}
