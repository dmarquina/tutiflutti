import 'package:scoped_model/scoped_model.dart';
import './category.dart';
import './user.dart';
import './user_input.dart';
import './game_development.dart';

class MainModel extends Model with CategoryModel, UserModel, UserInputModel, GameDevelopmentModel {}
