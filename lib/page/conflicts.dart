import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/conflict.dart';
import 'package:tutiflutti/scoped_model/main.dart';

class ConflictsPage extends StatelessWidget {
//  Widget fetchAnswers(MainModel model) {
//    return Flexible(
//      child: ListView.builder(
//          itemBuilder: (BuildContext context, int index) {
//            return Dismissible(
//              key: Key('${model.username}${categories[index]}${inputs[index]}'),
//              direction: DismissDirection.horizontal,
//              onDismissed: (DismissDirection direction) {
//                if (direction == DismissDirection.startToEnd) {
//                } else if (direction == DismissDirection.endToStart) {}
//              },
//              background: Container(
//                color: Colors.green,
//                child: Icon(Icons.check_circle, color: Colors.white, size: 42.0),
//              ),
//              secondaryBackground: Container(
//                color: Colors.red,
//                child: Icon(Icons.cancel, color: Colors.white, size: 42.0),
//              ),
//              child: Column(children: <Widget>[
//                ListTile(title: Text(_conflicts[0].category), subtitle: Text(_conflicts[0].input)),
//                Divider(
//                  height: 2.0,
//                )
//              ]),
//            );
//          },
//          itemCount: _conflicts.length),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Conflictos'),
        ),
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  model.gameLetter,
                  style: TextStyle(fontSize: 56.0),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text('¿Estas respuestas son correctas?'),
                Text('HOOOOOOLI'),
                SizedBox(
                  height: 30.0,
                ),
                Divider(
                  height: 2.0,
                ),
//                fetchAnswers(model),
              ],
            ),
          ),
        ),
      );
    });
  }
}
