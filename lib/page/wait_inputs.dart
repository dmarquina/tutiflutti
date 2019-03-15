import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';

class WaitInputsPage extends StatefulWidget {
  final MainModel _model;

  WaitInputsPage(this._model);

  @override
  WaitInputsPageState createState() => WaitInputsPageState();
}

class WaitInputsPageState extends State<WaitInputsPage> {
  StreamSubscription _subscriptionInputsIsOver;
  BuildContext _context;

  @override
  initState() {
    widget._model
        .watchIfInputsIsOver(goToReview, widget._model.userId)
        .then((StreamSubscription s) => _subscriptionInputsIsOver = s);
    super.initState();
  }

  @override
  void dispose() {
    _subscriptionInputsIsOver.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.TITLE),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 10.0),
            Text('Esperando a la gente :3')
          ],
        ),
      ),
    );
  }

  goToReview() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(_context, Constants.REVIEW_PATH);
    });
  }
}
