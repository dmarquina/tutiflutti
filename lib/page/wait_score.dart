import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/page/score.dart';
import 'package:tutiflutti/repository/reviews_conflicts.dart';
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
  ReviewsConflictsRepository reviewsConflictsRepository;

  @override
  initState() {
    reviewsConflictsRepository = ReviewsConflictsRepository(widget._model.gameId);
    reviewsConflictsRepository
        .watchIfConflictIsOver(goToScore, widget._model.userId, widget._model.usersLength)
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
        appBar: Theme.of(context).platform == TargetPlatform.iOS
            ? CupertinoNavigationBar(
                middle: Text(Constants.TITLE, style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.teal,
                automaticallyImplyLeading: false)
            : AppBar(title: Text(Constants.TITLE), automaticallyImplyLeading: false),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator(),
                SizedBox(height: 10.0),
                Text('Calculando el puntaje...')
              ],
            ),
          ),
        ),
      );
    });
  }

  goToScore() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          _context, MaterialPageRoute(builder: (context) => ScorePage(widget._model)));
    });
  }
}
