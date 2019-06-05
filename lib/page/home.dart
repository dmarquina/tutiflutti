import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';
import 'package:tutiflutti/util/ui/rounded_button.dart';

class HomePage extends StatefulWidget {
  MainModel _model;

  HomePage(this._model);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var usernameController = TextEditingController();
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    usernameController.text = widget._model.username;
    _context = context;
    return Scaffold(
        appBar: Theme.of(context).platform == TargetPlatform.iOS
            ? CupertinoNavigationBar(
                middle: Text(Constants.TITLE, style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.teal)
            : AppBar(title: Text(Constants.TITLE), centerTitle: true),
        body: Container(
            margin: EdgeInsets.only(top: 100.0),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Text('¿Cómo debemos llamarte?', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 10.0),
              _buildInputUsername(),
              SizedBox(height: 10.0),
              _buildSubmitButton(widget._model, context)
            ]))));
  }

  Widget _buildInputUsername() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
            onSubmitted: (text) {
              searchGames();
            },
            controller: usernameController,
            textAlign: TextAlign.center,
            maxLength: 12,
            decoration: InputDecoration(
                hintStyle: new TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(const Radius.circular(50.0))))));
  }

  Widget _buildSubmitButton(MainModel model, BuildContext context) {
    return Container(
        child: Row(children: <Widget>[
      Expanded(child: RoundedButton.big(Colors.teal, _readyText(), searchGames))
    ]));
  }

  Widget _readyText() => Text('¡VAMOS!', style: TextStyle(color: Colors.white, fontSize: 18.0));

  searchGames() {
    widget._model.createUpdateUser(usernameController.text);
    Navigator.pushNamed(_context, Constants.ROOMS_PATH);
  }
}
