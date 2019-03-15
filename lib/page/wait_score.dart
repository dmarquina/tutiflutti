import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';

class WaitScorePage extends StatefulWidget {
  MainModel _model;

  WaitScorePage(this._model);

  @override
  WaitScorePageState createState() => WaitScorePageState();
}

class WaitScorePageState extends State<WaitScorePage> {
  StreamSubscription _subscriptionConflictReviewIsOver;
  BuildContext _context;

  @override
  initState() {
    widget._model
        .watchIfConflictIsOver(goToScore,widget._model.userId)
        .then((StreamSubscription s) => _subscriptionConflictReviewIsOver = s);
    super.initState();
  }

  @override
  void dispose() {
    _subscriptionConflictReviewIsOver.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(title: Text(Constants.TITLE)),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 10.0),
                Text('Preparando el puntaje...')
              ],
            ),
          ),
        ),
      );
    });
  }

  goToScore() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(_context, Constants.SCORE_PATH);
    });
  }
}
