import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';
import 'package:tutiflutti/util/ui/rounded_button.dart';

class HomePage extends StatelessWidget {
  final _usernameController = TextEditingController();
  MainModel _model;
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.TITLE),
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
            _buildInputUsername(),
            ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
              _model = model;
              return _buildSubmitButton(model, context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInputUsername() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          controller: _usernameController,
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
        ));
  }

  Widget _buildSubmitButton(MainModel model, BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(children: <Widget>[
          Expanded(
            child: RoundedButton.big(Colors.teal, _readyText(), startGame),
          ),
        ]));
  }

  Widget _readyText() =>
      Text('¡VAMOS!', style: TextStyle(color: Colors.white,fontSize: 18.0));

  startGame() {
    _model.createUser(_usernameController.text);
    Navigator.pushReplacementNamed(_context, Constants.ROOMS_PATH);
  }
}
