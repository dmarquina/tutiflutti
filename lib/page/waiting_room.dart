import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/rainbow_colors.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class WaitingRoom extends StatefulWidget {
  final MainModel _model;

  WaitingRoom(this._model);

  @override
  WaitingRoomState createState() {
    return new WaitingRoomState();
  }
}

class WaitingRoomState extends State<WaitingRoom> {
  @override
  void initState() {
    widget._model.getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          appBar: AppBar(
            title: Text('SALA DE ESPERA'),
          ),
          body: Container(
            color: Colors.black87,
            child: Column(children: <Widget>[
              Expanded(
                  flex: 8,
                  child: FirebaseAnimatedList(
                      query: widget._model.getAllUsers(),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(vertical: 25.0),
                            child: Text(
                              snapshot.value['username'],
                              style: TextStyle(
                                  fontSize: 24.0,
                                  color: RainbowColors.rainbowColor(index < 7 ? index : index - 7)),
                            ));
                      })),
              Expanded(
                  flex: 2,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/startgame');
                    },
                    child: Text(
                      "¡A JUGAR!",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ))
            ]),
          ));
    });
  }
}
