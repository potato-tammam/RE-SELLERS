
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import '../Models/Comment.dart';
import '../Models/http_Exception.dart';
import '../core/color.dart';

class Comments with ChangeNotifier{
  List<Comment> _comments = [];

  List<Comment> get comments => [..._comments];

Comment? _comment = null ;

  Comment? get comment => _comment;

  final String? authToken ;
  final String? userid ;

  Comments(this.authToken, this.userid , this._comments);


  Future<void> GetAllComments (int prodid) async {
    final url = Uri.parse(
        "$Url/products/$prodid/Comments");

    try {
      var   headers =  {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.get(url , headers: headers );
      final exctracteddatat = json.decode(responce.body)  ;
     // print(exctracteddatat.toString());
      final List<Comment> loadedReviews = [];

      if(exctracteddatat == null ){
        print("no Comments") ;
        return;
      }

      exctracteddatat.forEach((v) {
        loadedReviews.add(
            Comment(
              data: v['comment'],
              id: v['id'],
              productId: v['product_id'] ,
              userId: v['user_id'] ,
              name: v["full_name"],
            ));
      });

      _comments = loadedReviews ;
      // _comments.forEach((element) {
      //   print(element.userId);
      //   print(element.data);
      // });
    //  print(_comments.length);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void>GetMyCommentOnThisProduct(int proId ) async {
    print(userid);
    final url = Uri.parse(
        "$Url/products/$proId/Comment-Check/$userid");

    try {
      var   headers =  {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.get(url , headers: headers );
      if(responce.statusCode >400){
        print("np comments");
        _comment = null ;
        return  ;
        // throw HttpException("soso");
      }
      if(responce.body == "comment not found"){
        print("no comments");
        _comment = null ;
        return  ;
        //throw HttpException("soso");
      }
      if(responce.body == "You have not commented on this product yet! "){
        print("no comments");
        _comment = null ;
        return  ;
        //throw HttpException("soso");
      }
      if(responce.body == ""){
        print("no comments");
        _comment = null ;
        return  ;
        //throw HttpException("soso");
      }
      final exctracteddatat = json.decode(responce.body)  ;


      print(exctracteddatat.toString());
      if(exctracteddatat == null ){
        print("no products") ;
        return ;
      }

      _comment =  Comment(
        id: exctracteddatat["id"],
        name :exctracteddatat["full_name"],
        data:   exctracteddatat['comment'],
        productId: exctracteddatat['product_id'] ,
        userId: exctracteddatat['user_id'] ,
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> AddComment (String com , prodid) async {
    final url = Uri.parse(
        "$Url/products/$prodid/Comments");

    try {
      var   headers =  {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.post(url , headers: headers ,body: {
        "comment" : com ,
      });
      final exctracteddatat = json.decode(responce.body)  ;
      print(exctracteddatat.toString());

      if(exctracteddatat == null ){
        print("no comments") ;
        return;
      }
      print("Success");
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> EditeComment (int comId  , int prodid,  String com ) async {
    final url = Uri.parse(
        "$Url/products/$prodid/update-Comments/$comId");

    try {
      var   headers =  {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.put(url , headers: headers ,body: {
        "comment" : com ,
      });
      if(responce.body == "Comment Not Found"){
        print("np comments");
        throw HttpException("soso");
      }
      if(responce.body == "you cannot edit this comment"){
        print("not authinticated");
        throw HttpException("soso");
      }
      final exctracteddatat = json.decode(responce.body)  ;
      print(exctracteddatat.toString());

      if(exctracteddatat == null ){
        print("no Reviews") ;
        return;
      }
      print("Success");
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> DelleteComment (int comid , int prodid  ) async {
    final url = Uri.parse(
        "$Url/products/$prodid/delete-Comment/$comid");

    try {
      var   headers =  {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.delete(url , headers: headers ,);
      if(responce.body == "couldn't find the comment"){
        print("np reviews");
        throw HttpException("soso");
      }

      if(responce.body == "this comment have been deleted"){
        //  reviews.removeWhere((element) => element.id == reviewId);
        print("done deleted");
        notifyListeners();
        return;
      }

    } catch (error) {
      throw error;
    }
  }

}