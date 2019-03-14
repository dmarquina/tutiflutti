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
      body: StreamBuilder(
          stream: widget._model.getScoreBoard(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Map<dynamic, dynamic> userInputs = Map.from(snapshot.data.value);
              return Column(
                  children: userInputs.values
                      .toList()
                      .map((a) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                          child: Card(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(a['score'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 20.0)),
                                      SizedBox(height: 2.0),
                                      Text(a['username'],
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                      _buildInputs(a)
                                    ],
                                  )))))
                      .toList());
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget _buildInputs(dynamic a) {
    return Column(
        children: Map.from(a['inputs'])
            .map<dynamic, String>((key, value) => MapEntry(key, '$key: $value'))
            .values
            .toList()
            .map((value) => Text(value, textAlign: TextAlign.left))
            .toList());
  }
}
