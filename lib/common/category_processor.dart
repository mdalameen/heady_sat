import 'package:heady_sat/models/items.dart';

class CategoryProcessor {
  static final CategoryProcessor _instance = CategoryProcessor._internal();
  CategoryProcessor._internal();
  factory CategoryProcessor() => _instance;

  Set<int> _selectedCategories = Set();
  ItemOut _data;

  void setData(ItemOut data) {
    _selectedCategories.clear();
    this._data = data;

    // Map<int, Product> allProducts = Map();
    // if (data != null) {
    //   for (Category c in data.categories) {
    //     for (Product p in c.products) {
    //       allProducts[p.id] = p;
    //     }
    //   }
    //   for (Ranking r in data.rankings) {
    //     for (RankingProduct rp in r.rankingProducts) {
    //       // rankingProducts[rp.]
    //     }
    //   }
    // }
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
    List<Product> products = List();
    if (_data != null) {
      for (Category c in _data.categories) {
        if (_selectedCategories.isEmpty ||
            _selectedCategories.contains(c.id) ||
            (toSelectCategoryId != null && toSelectCategoryId == c.id)) {
          for (Product p in c.products)
            if (!products.contains(p)) products.add(p);
          if (toSelectCategoryId != null)
            break;
          else if (c.childCategories.isNotEmpty &&
              _selectedCategories.isNotEmpty)
            for (int category in c.childCategories)
              products.addAll(getProducts(category));
        }
      }
    }
    return products;
  }
}
