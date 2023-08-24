import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/Product.dart';
import '../Models/http_Exception.dart';
import '../core/color.dart';
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _lastFour = [];
  List<Product> _userItems = [];
  List<Product> _items = [];
  int? _category = 0;

  final String? authToken;

  final String? userid;

  Products(this.authToken, this.userid, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get lastfour {
    return [..._lastFour];
  }

  List<Product> get useritems {
    return [..._userItems];
  }

  List<Product> get FavoritItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  get categoryid {
    return _category;
  }

  set category(int value) {
    _category = value;
    notifyListeners();
  }

  List<Product> get SortedByCategory {
    if (_category == 0) {
      return [..._items];
    }
    return _items
        .where((element) => element.categoryId == _category.toString())
        .toList();
  }

  Product FindById(String Id) {
    return _items.firstWhere((prod) => prod.id == Id);
  }

  Future<void> FetchProducts() async {
    final url = Uri.parse("$Url/all-products");

    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.get(url, headers: headers);
      final exctracteddatat = json.decode(responce.body);
      // print(exctracteddatat[0].toString());
      final List<Product> loadedProducts = [];

      if (exctracteddatat == null) {
        print("no products");
        return;
      }

      exctracteddatat.forEach((v) {
        loadedProducts.add(Product(
          id: v['product']["id"].toString(),
          condition: v['product']["condition"].toString(),
          categoryId: v['product']["category_id"].toString(),
          creator_name: v['product']["Full_name"].toString(),
          product_creator_id: v['product']["product_creator"].toString(),
          description: v['product']['description'].toString(),
          price: double.parse(v['product']["price"]),
          status: v['product']['status'].toString(),
          title: v['product']["name"].toString(),
          imageUrl: v["imageUrl"].toString(),
          isFavorite: v["is_favorite"] == "not_favorite" ? false : true,
        ));
      });
      _items = loadedProducts;
      // _items.forEach((element) {
      //   print(element.imageUrl);
      //   print(element.categoryId);
      // });
      print(_items.length);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> FetchMyProducts() async {
    final url = Uri.parse("$Url/my_products");

    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.get(url, headers: headers);
      if (responce.body == "No Products Found ! you can add new products") {
        print("you have no products");
        return;
      }
      final exctracteddatat = json.decode(responce.body);
      // print(exctracteddatat.toString());
      final List<Product> loadedProducts = [];

      if (exctracteddatat == null) {
        print("no products");
        return;
      }

      exctracteddatat.forEach((v) {
        if (v['product']['status'].toString() != "inactive") {
          loadedProducts.add(Product(
            id: v['product']["id"].toString(),
            condition: v['product']["condition"].toString(),
            categoryId: v['product']["category_id"].toString(),
            creator_name: v['product']["Full_name"].toString(),
            product_creator_id: v['product']["product_creator"].toString(),
            description: v['product']['description'].toString(),
            price: double.parse(v['product']["price"]),
            status: v['product']['status'].toString(),
            title: v['product']["name"].toString(),
            imageUrl: v["image"].toString(),
            isFavorite: v["is_favorite"] == "not_favorite" ? false : true,
          ));
        }
      });
      _category = 0;
      _userItems = loadedProducts;
      // _userItems.forEach((element) {
      //   print(element.imageUrl);
      // });
      // print(_userItems.length);
      //
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> AddProduct(Product prod) async {
    final url = Uri.parse("$Url/create-product");
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $authToken',
    };
    try {
      final request = http.MultipartRequest(
        'POST',
        url,
      );
      request.fields.addAll(
        {
          'name': prod.title.toString(),
          'description': prod.description.toString(),
          'price': prod.price.toString(),
          "category_id": prod.categoryId.toString(),
          "condition": prod.condition.toString()
          //'creatorId' : userid ,
        },
      );
      request.files
          .add(await http.MultipartFile.fromPath('path', prod.imageUrl));
      request.headers.addAll(headers);
      final responce = await request.send();

      if (responce.statusCode == 200) {
        print("success");
        print(await responce.stream.bytesToString());
      } else {
        print(responce.reasonPhrase);
      }

      print(responce.reasonPhrase.toString());
      // final newprod = Product(
      //     id: json.decode(responce.body)['id'],
      //     title: prod.title,
      //     description: prod.description,
      //     imageUrl: prod.imageUrl,
      //     price: prod.price);
      // _items.add(newprod);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> Updateprdocut(
      String prodid, Product prod, bool imagechanged) async {
    final prodIndex = _items.indexWhere((element) => element.id == prodid);
    if (prodIndex >= 0) {
      final url = Uri.parse("$Url/edit-product/$prodid");
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      try {
        final request = http.MultipartRequest(
          'POST',
          url,
        );
        request.fields.addAll(
          {
            'name': prod.title.toString(),
            "category_id": prod.categoryId.toString(),
            'description': prod.description.toString(),
            'price': prod.price.toString(),
            "condition": prod.condition.toString()
          },
        );
        if (imagechanged) {
          request.files
              .add(await http.MultipartFile.fromPath('path', prod.imageUrl));
        }

        request.headers.addAll(headers);
        final responce = await request.send();

        if (responce.statusCode == 200) {
          print("success");
          print(await responce.stream.bytesToString());
        } else {
          print(await responce.stream.bytesToString());
          print(responce.reasonPhrase);
        }

        print(responce.reasonPhrase.toString());
        // final newprod = Product(
        //     id: prodid,
        //     title: prod.title,
        //     description: prod.description,
        //     imageUrl: prod.imageUrl,
        //     price: prod.price);
        // _items.add(newprod);
        // notifyListeners();

      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Future<void> DeletProduct(String prodid) async {
    final url = Uri.parse("$Url/delete-product/$prodid");
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $authToken',
    };
    final _itemsindex = _items.indexWhere((element) => element.id == prodid);
    Product? _thedeletetItem = _items[_itemsindex];
    _items.removeAt(_itemsindex);
    notifyListeners();

    final responce = await http.delete(url, headers: headers);
    print(responce.body.toString());
    if (responce.body == "OK") {
      return;
    }
    if (responce.statusCode >= 400 && responce.statusCode < 500) {
      _items.insert(_itemsindex, _thedeletetItem);
      notifyListeners();
      throw HttpException("could not delete");
    }
    _thedeletetItem = null;
  }

  Future<void> GetLAstFourProducts() async {
    final url = Uri.parse("$Url/lastFour");

    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.get(url, headers: headers);
      final exctracteddatat = json.decode(responce.body);
      // print(exctracteddatat.toString());
      final List<Product> loadedProducts = [];

      if (exctracteddatat == null) {
        print("no products");
        return;
      }

      exctracteddatat.forEach((v) {
        loadedProducts.add(Product(
          id: v['product']["id"].toString(),
          condition: v['product']["condition"].toString(),
          categoryId: v['product']["category_id"].toString(),
          creator_name: v['product']["Full_name"].toString(),
          product_creator_id: v['product']["product_creator"].toString(),
          description: v['product']['description'].toString(),
          price: double.parse(v['product']["price"]),
          status: v['product']['status'].toString(),
          title: v['product']["name"].toString(),
          imageUrl: v["imageUrl"].toString(),
          isFavorite: v["is_favorite"] == "not_favorite" ? false : true,
        ));
      });

      _lastFour = loadedProducts;
      // _lastFour.forEach((element) {
      //   print(element.title );
      // });

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> SetFavorit(bool isFavorite, String id) async {
    final oldstatuse = isFavorite;
    isFavorite = !isFavorite;
    final _itemsindex = _items.indexWhere((element) => element.id == id);
    Product? _thedeletetItem = _items[_itemsindex];
    _thedeletetItem.isFavorite = isFavorite;
    notifyListeners();
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $authToken',
    };
    final url = Uri.parse("$Url/love_button/$id");
    try {
      final responce = await http.get(url, headers: headers);
      print(responce.body);
      if (responce.statusCode >= 400) {
        isFavorite = oldstatuse;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldstatuse;
      notifyListeners();
    }
  }
}
