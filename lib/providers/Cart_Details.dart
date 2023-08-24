import 'package:flutter/cupertino.dart';
import 'package:shop_app/Models/http_Exception.dart';

class CartItem {
  final String id;
  final String creatordid;
  final String tilte;

  final int quantity;

  final double price;

  CartItem(
      {required this.id,
        required this.creatordid,
      required this.tilte,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  final String? _user_id ;
  Map<String, CartItem> _items = {};

  Cart(this._user_id);

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get ItemCount {
    return _items.isEmpty ? 0 : _items.length;
  }

  double get ToltalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void AddItem(String productId,String creatorid, String title, double price) {
    if(creatorid == _user_id ){
      throw HttpException("soso");
    }
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartItem(
            id: value.id,
            tilte: value.tilte,
            quantity: value.quantity + 1,
            creatordid: value.creatordid,
            price: value.price),
      );
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: productId,
              tilte: title,
              quantity: 1,
              creatordid: creatorid,
              price: price));
    }
    notifyListeners();
  }

  void RemoveItem(String prodId) {
    _items.remove(prodId);
    notifyListeners();
  }

  void removSingleItem(String prodid) {
    if (!_items.containsKey(prodid)) {
      return;
    }
    if (_items[prodid]!.quantity > 1) {
      _items.update(
          prodid,
          (value) => CartItem(
              id: value.id,
              tilte: value.tilte,
              quantity: value.quantity - 1,
              creatordid: value.creatordid,
              price: value.price));
    }else{
      _items.remove(prodid);
    }
    notifyListeners();
  }

  void ClearCart() {
    _items.clear();
    notifyListeners();
  }
}
