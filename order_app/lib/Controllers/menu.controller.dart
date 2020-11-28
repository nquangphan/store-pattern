import 'dart:typed_data';

import 'package:rxdart/rxdart.dart';
import './../Models/home.model.dart' ;
import './../Models/history.model.dart' ;
import './../Models/menu.model.dart';
import 'package:order_app/Models/menu.model.dart' ;
import 'package:order_app/Models/cart.model.dart' ;

class MenuController {
  static MenuController _instance;

  static MenuController get instance {
    if (_instance == null) _instance = new MenuController();
    return _instance;
  }

  Future<List<FoodCategory>> _foodCategories;

  // Future<List<Food>> _foods;

  Future<List<FoodCategory>> get foodCategories {
    if (_foodCategories == null)
      _foodCategories = MenuModel.instance.foodCategories;
    return _foodCategories;
  }

  // Future<List<Food>> get foods {
  //   if (_foods == null) _foods = Model.instance.foods;
  //   return _foods;
  // }

  Future<List<Food>> filterFoods(String category) async {
    List<Food> _foods = await foods();
    int idCategory = await getIdCategory(category);
    if (idCategory == -1) return _foods;
    return _foods.where((_food) => _food.idFoodCategory == idCategory).toList();
  }

  Future<int> getIdCategory(String category) async {
    List<FoodCategory> _foodCategories = await foodCategories;
    for (var item in _foodCategories) {
      if (item.name == category) return item.id;
    }
    return -1;
  }

  Future<List<Food>> searchFoods(
      String selectedCategory, String keyword) async {
    List<Food> _foods = await filterFoods(selectedCategory);
    if (keyword.trim() == '') return _foods;
    return _foods
        .where((_food) =>
            _food.name.toLowerCase().indexOf(keyword.trim().toLowerCase()) !=
            -1)
        .toList();
  }

  Future<List<Food>> _foods;
  Future<Map<int, Uint8List>> _images;

  Future<List<Food>> foods() {
    if (_foods == null) {
      _images = _syncMySqlWithFile();
      _foods = _combineFoodsImages(_images, MenuModel.instance.foods);
    }
    return _foods;
  }

  Future<Map<int, Uint8List>> get _imagesFile => MenuModel.instance.imagesFile;

  Future<List> get _idImagesMySQL => MenuModel.instance.idImagesMySQL;

  Future<Uint8List> _getImageByID(int id) => MenuModel.instance.getImageById(id);

  void _combine(Food food, Uint8List image) => food.image = image;

  Future<void> _saveFile(int id, Uint8List image) async =>
      MenuModel.instance.saveImage(id, image);

  Future<void> _deleteFile(int id) async => MenuModel.instance.delete(id);

  //Future<List<FoodCategory>> get foodCategories => Model.instance.foodCategories;

  Future<List<Food>> _combineFoodsImages(
      Future<Map<int, Uint8List>> futureImages,
      Future<List<Food>> futureFoods) async {
    Map<int, Uint8List> images = await futureImages;
    List<Food> foods = await futureFoods;
    for (int i = 0; i < foods.length; ++i) {
      _combine(foods[i], images[foods[i].idImange]);
    }
    return foods;
  }

  Future<Map<int, Uint8List>> _syncMySqlWithFile() async {
    List idImagesMySQL = await this._idImagesMySQL;
    Map<int, Uint8List> imagesFile = await this._imagesFile;
    Map<int, Uint8List> images = {};
    int id = 0;
    for (int i = 0; i < idImagesMySQL.length; ++i) {
      id = int.parse(idImagesMySQL[i]['ID']); // id in database
      if (imagesFile[id] == null) {
        final temp = await _getImageByID(id);
        _saveFile(id, temp); // save async image in database to file
        images[id] = temp;
      } else {
        images[id] = imagesFile[id];
        imagesFile.remove(id); // remove async image exists in database
      }
    }
    imagesFile.forEach((key, value) => _deleteFile(key));

    /// delete Image don't exists in database
    return images;
  }

  Future<int> getIdBillByTable(int idTable) {
    return CartModel.instance.getIdBillByTable(idTable);
  }

  Future<List<Food>> getListFoodByTable(AppTable table) async {
    List<Food> listFoods = await foods();
    if (table.status == 1) {
      int idBill = await MenuController.instance.getIdBillByTable(table.id);
      table.foods.clear();
      table.foods.addAll(await _combineFoodsImages(
          _images, HistoryModel.instance.getBillDetailByBill(idBill)));
    }
    return listFoods;
  }
}
