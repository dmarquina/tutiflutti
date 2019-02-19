import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/user_input.dart';
import 'package:tutiflutti/scoped_model/main.dart';

class HomePage extends StatelessWidget {
  final _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TUTI FLUTI'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 100.0),
        child: Column(
          children: <Widget>[
            Text(
              'Ingresa tu usuario',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _userNameController,
                  textAlign: TextAlign.center,
                  maxLength: 12,
                  decoration: InputDecoration(
                    hintStyle: new TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                    ),
                  ),
                )),
            ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
              return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text('INICIAR'),
                        onPressed: () {
                          model.setUserName(_userNameController.text);
                          model.addUser(new User(_userNameController.text, gameId: '1'));
                          Navigator.pushReplacementNamed(context, '/waitingroom');
                        },
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ),
                    ),
                  ]));
            }),
          ],
        ),
      ),
    );
  }
}
