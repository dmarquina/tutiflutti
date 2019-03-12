import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/conflict.dart';
import 'package:tutiflutti/scoped_model/main.dart';

class ScorePage extends StatefulWidget {
  MainModel _model;

  ScorePage(this._model);

  @override
  ScorePageState createState() => ScorePageState();
}

class ScorePageState extends State<ScorePage> {
  @override
  initState() {
    widget._model.getScoreBoard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Puntaje')),
      body: Container(
        child: Center(
          child: StreamBuilder(
              stream: widget._model.getScoreBoard(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  Map<dynamic, dynamic> userInputs = Map.from(snapshot.data.value);
                  return Column(
                      children: userInputs.values
                          .toList()
                          .map((a) => Container(child: Text(a['username'])))
                          .toList());
                }else {
                  return CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}
