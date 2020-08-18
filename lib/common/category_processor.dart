import 'package:heady_sat/models/items.dart';

class CategoryProcessor {
  static final CategoryProcessor _instance = CategoryProcessor._internal();
  CategoryProcessor._internal();
  factory CategoryProcessor() => _instance;

  Set<int> _selectedCategories = Set();
  Map<int, Product> _allProducts = Map();
  ItemOut _data;

  void setData(ItemOut data) {
    _selectedCategories.clear();
    this._data = data;

    _allProducts.clear();
    if (data != null) {
      for (Category c in data.categories) {
        for (Product p in c.products) {
          _allProducts[p.id] = p;
        }
      }
    }
  }

  Map<int, Product> getProductMap() {
    return _allProducts;
  }

  Set<int> getSelectedCategory() {
    return _selectedCategories;
  }

  void resetCategory() {
    _selectedCategories.clear();
  }

  void toggleCategory(int categoryId) {
    if (_selectedCategories.contains(categoryId))
      _selectedCategories.remove(categoryId);
    else
      _selectedCategories.add(categoryId);
  }

  List<Product> getProducts([int toSelectCategoryId]) {
    Set<Product> products = Set();
    if (_data != null) {
      for (Category c in _data.categories) {
        if ((toSelectCategoryId == null && _selectedCategories.isEmpty) ||
            (toSelectCategoryId == null &&
                _selectedCategories.contains(c.id)) ||
            (toSelectCategoryId != null && toSelectCategoryId == c.id)) {
          products.addAll(c.products);

          if (c.childCategories.isNotEmpty && _selectedCategories.isNotEmpty)
            for (int category in c.childCategories) {
              products.addAll(getProducts(category));
            }
        }
      }
    }
    return products.toList();
  }
}
