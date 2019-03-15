import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';

class WaitReviewsPage extends StatefulWidget {
  final MainModel _model;

  WaitReviewsPage(this._model);

  @override
  WaitReviewsPageState createState() => WaitReviewsPageState();
}

class WaitReviewsPageState extends State<WaitReviewsPage> {
  StreamSubscription _subscriptionReviewIsOver;
  BuildContext _context;

  @override
  initState() {
    widget._model
        .watchIfReviewIsOver(goToConflicts, goToScore)
        .then((StreamSubscription s) => _subscriptionReviewIsOver = s);
    super.initState();
  }

  @override
  void dispose() {
    _subscriptionReviewIsOver.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoNavigationBar(
              middle: Text(Constants.TITLE, style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.teal)
          : AppBar(
              title: Text(Constants.TITLE),
            ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoActivityIndicator()
                : CircularProgressIndicator(),
            SizedBox(height: 10.0),
            Text('Esperando a la gentita :3')
          ],
        ),
      ),
    );
  }

  goToConflicts() => Navigator.pushReplacementNamed(_context, Constants.CONFLICTS_PATH);

  goToScore() => Navigator.pushReplacementNamed(_context, Constants.SCORE_PATH);
}
