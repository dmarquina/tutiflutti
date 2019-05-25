import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/page/conflicts.dart';
import 'package:tutiflutti/page/review.dart';
import 'package:tutiflutti/page/rooms.dart';
import 'package:tutiflutti/page/home.dart';
import 'package:tutiflutti/page/filling_time.dart';
import 'package:tutiflutti/page/score.dart';
import 'package:tutiflutti/page/wait_inputs.dart';
import 'package:tutiflutti/page/wait_reviews.dart';
import 'package:tutiflutti/page/wait_score.dart';
import 'package:tutiflutti/page/waiting_room.dart';
import 'package:tutiflutti/scoped_model/main.dart';
import 'package:tutiflutti/util/constants.dart';

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
          title: Constants.TITLE,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              buttonTheme: ButtonThemeData(buttonColor: Colors.teal),
              primarySwatch: Colors.teal,
              primaryColor: Colors.teal,
              accentColor: Colors.redAccent),
          routes: {
            Constants.HOME_PATH: (BuildContext context) => HomePage(_model),
            Constants.ROOMS_PATH: (BuildContext context) => RoomsPage(),
            Constants.WAITING_ROOM_PATH: (BuildContext context) => WaitingRoom(_model),
            Constants.START_GAME_PATH: (BuildContext context) => FillingTimePage(_model),
            Constants.WAIT_INPUT_PATH: (BuildContext context) => WaitInputsPage(_model),
            Constants.REVIEW_PATH: (BuildContext context) => ReviewPage(),
            Constants.WAIT_REVIEWS_PATH: (BuildContext context) => WaitReviewsPage(_model),
            Constants.CONFLICTS_PATH: (BuildContext context) => ConflictsPage(),
            Constants.WAIT_SCORE_PATH: (BuildContext context) => WaitScorePage(_model),
            Constants.SCORE_PATH: (BuildContext context) => ScorePage(_model),
          },
        ));
  }
}
