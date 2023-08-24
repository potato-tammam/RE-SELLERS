import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/Cart_Details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../core/color.dart';

class OrderItem {
  final String Id;

  final double total;

  final List<CartItem> OrderItems;



  OrderItem(
      {required this.Id,
      required this.total,
      required this.OrderItems,
     });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken ;
  final String? userId ;

  Order(this.authToken , this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addoroder(List<CartItem> cartproduct, double total) async {
   cartproduct.forEach((element) {
     print(element.id);
     print(element.creatordid);
     print(element.tilte);
     print(element.price);
   });
    final url = Uri.parse(
        "$Url/add_order");
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
  var body = jsonEncode({
     'total_price': total,
     'ordered_items': cartproduct
         .map((e) =>
     {
       "id": e.id,
       "product_creator" : e.creatordid,
       "price": e.price.toString(),
     }
     ).toList(),
   } );
  print(body.toString());
    try {
      final responce = await http.post(url,
          body:body,
      headers:  headers
      );
    print(responce.body);
      if(responce.body == "You Order is being checked"){
        _orders.insert(
          0,
          OrderItem(
            Id: "",
            total: total,
            OrderItems: cartproduct,
          ),
        );
        notifyListeners();
      }

      notifyListeners();
    } catch (error) {
      print(error);
    }

  }

  Future<void> FetchOrders() async {
    final url = Uri.parse(
        "$Url/show_orders");

    try {
      var   headers =  {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.get(url , headers: headers );
      print(responce.body.toString());
      if(responce.body == "No Orders have been Made"){
        print("sosoo");
        return ;
      }
    final exctracteddatat = json.decode(responce.body) ;
    final List<OrderItem> loadedProducts = [];
    if(exctracteddatat == null ){
      return ;
    }
   // print(exctracteddatat.toString());
    exctracteddatat.forEach((orderdata) {
      loadedProducts.add(
        OrderItem(
          Id:  orderdata["order_id"].toString() ,
          total:double.parse(orderdata["order_price"]),
          OrderItems: (orderdata["ordered_items"] as List<dynamic>)
              .map((e) => CartItem(
              id: e["id"].toString(),
              tilte: e["name"],
              quantity: 1,
              creatordid: e['product_creator'].toString(),
              price: double.parse(e["price"])))
              .toList(),
        ),
      );
    });
    _orders = loadedProducts.reversed.toList();
    _orders.forEach((element) {
      print(element.OrderItems.toString());
      print(element.total.toString());

    });
   notifyListeners();
    } catch (error) {
      print(error);
    }

  }
}
