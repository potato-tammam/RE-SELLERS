
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Models/http_Exception.dart';


import 'package:shop_app/core/color.dart';

class Product with ChangeNotifier{
  final String id;

  final String title;

  final String description;

  final String imageUrl;
  final double price;
  final String? condition;
  final String? categoryId ;
  bool isFavorite;
  String? status;
  String? product_creator_id;
  String? creator_name;

  Product( {required this.id,
    this.creator_name,
    this.product_creator_id,
    this.status,
    this.condition, this.categoryId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Future<void> SetFavorit(String? token ) async{
    final oldstatuse = isFavorite ;
   isFavorite = !isFavorite ;
   notifyListeners();
    var   headers =  {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    final url = Uri.parse(
        "$Url/love_button/$id");
    try{
    final responce =  await http.get(url , headers: headers);
    print(responce.body);
    print(responce.statusCode);
    if(responce.body ==" you can't add your own products" ){
      isFavorite = oldstatuse ;
      notifyListeners();

    }
    if(responce.statusCode >=400 ){
      isFavorite = oldstatuse ;
      notifyListeners();
      throw HttpException("wowo");
    }
    }catch(error){
      isFavorite = oldstatuse ;
      notifyListeners();
    }


  }
}