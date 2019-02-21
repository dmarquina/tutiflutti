import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/page/rooms.dart';
import 'package:tutiflutti/page/home.dart';
import 'package:tutiflutti/page/stage_category.dart';
import 'package:tutiflutti/page/waiting_room.dart';
import 'package:tutiflutti/scoped_model/main.dart';

void main() {
//  debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          title: 'TUTI FLUTTI',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          routes: {
            '/': (BuildContext context) => HomePage(),
            '/rooms': (BuildContext context) => RoomsPage(),
            '/waitingroom': (BuildContext context) => WaitingRoom(_model),
            '/startgame': (BuildContext context) => StageCategory(_model),
          },
        ));
  }
}
