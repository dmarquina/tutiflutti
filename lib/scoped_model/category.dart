import 'package:scoped_model/scoped_model.dart';

mixin CategoryModel on Model {
  List<String> _categories = new List.from(['Nombre', 'Apellido', 'País']);
  int _categoryIndex = 0;
  bool existsPrev = false;
  bool existsNext = true;

  String getActualCategory() => _categories[_categoryIndex];

  String getPreviousCategory() {
    if (_categoryIndex > 0) {
      --_categoryIndex;
      existsNext = true;
    }
    if ((_categoryIndex - 1) == 0) {
      existsPrev = false;
    }
    notifyListeners();
    return _categories[_categoryIndex];
  }

  String getNextCategory() {
    if (_categoryIndex < _categories.length) {
      ++_categoryIndex;
      existsPrev = true;
    }
    if ((_categoryIndex + 1) == _categories.length) {
      existsNext = false;
    }
    notifyListeners();
    return _categories[_categoryIndex];
  }
}
