import 'package:scoped_model/scoped_model.dart';
import './category.dart';
import './user_input.dart';

class MainModel extends Model with CategoryModel, UserInputModel {}
