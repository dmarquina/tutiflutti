import 'package:scoped_model/scoped_model.dart';

mixin CategoryModel on Model {
  List<String> _categories = new List.from(['Nombre', 'Apellido', 'País']);
  int _categoryIndex = 0;
  bool disabledPrev = true;
  bool disabledNext = false;

  String getActualCategory() => _categories[_categoryIndex];

  String getPreviousCategory() {
    if (_categoryIndex > 0) {
      --_categoryIndex;
      disabledNext = false;
    }
    if ((_categoryIndex) == 0) {
      disabledPrev = true;
    }
    notifyListeners();
    return _categories[_categoryIndex];
  }

  String getNextCategory() {
    if ((_categoryIndex + 1) < _categories.length) {
      ++_categoryIndex;
      disabledPrev = false;
    }
    if ((_categoryIndex + 1) == _categories.length) {
      disabledNext = true;
    }
    notifyListeners();
    return _categories[_categoryIndex];
  }
}
