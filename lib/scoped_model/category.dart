import 'package:scoped_model/scoped_model.dart';
import 'package:tutiflutti/model/category.dart';

mixin CategoryModel on Model {
  bool existsPrevCategory = false;
  bool existsNextCategory = false;
  Category _actualCategory;
  Map<String, Category> _categories = {};

  void fetchCategories() {
    Map<String, dynamic> categories = {
      'Nombre': {'actualCategory': 'Nombre', 'previousCategory': null, 'nextCategory': 'Apellido'},
      'Apellido': {
        'actualCategory': 'Apellido',
        'previousCategory': 'Nombre',
        'nextCategory': 'País'
      },
      'País': {'actualCategory': 'País', 'previousCategory': 'Apellido', 'nextCategory': null},
    };
    categories.forEach((String key, dynamic cat) {
      Category category = new Category(
        actualCategory: cat['actualCategory'],
        previousCategory: cat['previousCategory'],
        nextCategory: cat['nextCategory'],
      );
      _categories.putIfAbsent(key, () => category);
    });
    this.existsNextCategory = true;
    this.setActualCategory(_categories['Nombre']);
  }

  setActualCategory(Category cat) {
    _actualCategory = cat;
  }

  Category getActualCategory() {
    return _actualCategory;
  }

  setPreviousCategory() {
    setActualCategory(_categories[_actualCategory.previousCategory]);
    notifyListeners();
    this.existsNextCategory = true;
    if (_categories[_actualCategory.previousCategory] != null) {
      this.existsPrevCategory = true;
    } else {
      this.existsPrevCategory = false;
      notifyListeners();
    }
  }

  setNextCategory() {
    setActualCategory(_categories[_actualCategory.nextCategory]);
    notifyListeners();
    this.existsPrevCategory = true;
    if (_categories[_actualCategory.nextCategory] != null) {
      this.existsNextCategory = true;
    } else {
      this.existsNextCategory = false;
      notifyListeners();
    }
  }
}
