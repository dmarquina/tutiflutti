import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/conflict.dart';
import 'package:tutiflutti/scoped_model/main.dart';

class ScorePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(title: Text('Conflictos')),
        body: Container(
          child: Center(
            child: Text("Estamos en score :3"),
          ),
        ),
      );
    });
  }
}
