import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/scoped_model/main.dart';

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

  Color rainbowColor(int i) {
    Color color = Colors.black;
    switch (i) {
      case 0:
        color = Colors.red;
        break;
      case 1:
        color = Colors.orange;
        break;
      case 2:
        color = Colors.yellow;
        break;
      case 3:
        color = Colors.green;
        break;
      case 4:
        color = Colors.blue;
        break;
      case 5:
        color = Colors.indigo;
        break;
      case 6:
        color = Colors.purple;
        break;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          appBar: AppBar(
            title: Text('SALA DE ESPERA'),
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    widget._model.getAllUsers();
                  });
                },
              )
            ],
          ),
          body: Container(
            color: Colors.black87,
            child: Column(
              children: <Widget>[Expanded(
                flex: 8,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          widget._model.allUsers[index].username,
                          style: TextStyle(
                              fontSize: 24.0, color: rainbowColor(index < 7 ? index : index - 7)),
                        ));
                  },
                  itemCount: widget._model.allUsers.length,
                ),
              ),
              Expanded(flex: 2,child: FlatButton(onPressed: (){
                Navigator.pushReplacementNamed(context, '/startgame');
              }, child: Text("¡A JUGAR!",style: TextStyle(color: Colors.white,fontSize: 20.0),),))
              ]
            ),
          ));
    });
  }
}
