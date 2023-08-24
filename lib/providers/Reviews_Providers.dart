
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;

import 'dart:convert';

import '../Models/Review.dart';
import '../Models/http_Exception.dart';
import '../core/color.dart';

class Reviews with ChangeNotifier{
  List<Review>_reviews= [];
  Review? _myReview  = null ;


  Review? get myReview => _myReview;

  final String? authToken ;
  final String? userid ;

  Reviews(this.authToken, this.userid , this._reviews);



  List<Review> get reviews => [..._reviews];

  Future<void>GetMyReviewOnThisUser(int Id ) async {
    final url = Uri.parse(
        "$Url/reviews/$Id");

    try {
      var   headers =  {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.get(url , headers: headers );
      if(responce.statusCode >400){
        print("np reviews");
        _myReview = null ;
        return  ;
        // throw HttpException("soso");
      }
      if(responce.body == "You have not rated this user yet"){
        print("np reviews");
        _myReview = null ;

        return  ;
        //throw HttpException("soso");
      }
      if(responce.body == "[]"){
        print("np reviews");
        _myReview = null ;
        return ;
        //throw HttpException("soso");
      }

      final exctracteddatat = json.decode(responce.body)  ;


      print(exctracteddatat.toString());
      if(exctracteddatat == null ){
        print("no products") ;
        _myReview = null ;
        return null;
      }

     _myReview = Review(
        id: exctracteddatat[0]["id"],
        name : exctracteddatat[0]["full_name"],
        data:   exctracteddatat[0]['review'],
        rating :double.parse(exctracteddatat[0]['rating']) ,

      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> GetMyReviews () async {
    final url = Uri.parse(
        "$Url/user_reviews");

    try {
      var   headers =  {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.get(url , headers: headers );
      if(responce.statusCode >400){
        print("np reviews");
        return null ;
        // throw HttpException("soso");
      }
      if(responce.body == "You have not been rated yet"){
        print("np reviews");
        _reviews =[];
        notifyListeners();
        return ;
        //throw HttpException("soso");
      }
      final exctracteddatat = json.decode(responce.body)  ;
      print(exctracteddatat.toString());
      final List<Review> loadedReviews = [];

      if(exctracteddatat == null ){
        print("no products") ;
        return;
      }

      exctracteddatat.forEach((v) {
        loadedReviews.add(
            Review(
              id: 0,
              name : v["full_name"],
              data:   v['review'],
              rating :double.parse(v['rating'])  ,
            ));
      });

      _reviews = loadedReviews ;
      // _reviews.forEach((element) {
      //   print(element.name);
      //   print(element.data);
      // });
      // print(_reviews.length);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> GetUserReviews (int id ) async {
    final url = Uri.parse(
        "$Url/others_reviews/$id");

    try {
      var   headers =  {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.get(url , headers: headers );
      print(responce.statusCode);
      print(responce.body);
      if(responce.body == "User has not been rated yet"){
        print("np reviews");
        _reviews = [];
        notifyListeners();
        return ;
      }
      final exctracteddatat = json.decode(responce.body)  ;

      //print(exctracteddatat.toString());
      final List<Review> loadedReviews = [];


      exctracteddatat.forEach((v) {
        loadedReviews.add(
            Review(
              id: 0,
              name :v["full_name"],
              data:   v['review'],
              rating :double.parse(v['rating'])  ,
            ));
      });

      _reviews = loadedReviews ;
      // _reviews.forEach((element) {
      //   print(element.name);
      //   print(element.data);
      // });
      // print(_reviews.length);

      notifyListeners();
    } catch (error) {
      print(error.toString());
      _reviews = [];
      throw error;
    }
  }

  Future<void> AddReview (int id , double rating ,  String data ) async {
    if( userid == id ){
      throw HttpException("this u");
    }
    final url = Uri.parse(
        "$Url/reviews/$id");

    try {
      var   headers =  {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.post(url , headers: headers ,body: {
        "review" : data ,
        "rating" : rating.toString(),
      });
      if(responce.body == "you can't review yourself"){
        throw HttpException("this u");
      }
      final exctracteddatat = json.decode(responce.body)  ;
      print(exctracteddatat.toString());

      if(exctracteddatat == null ){
        print("no Reviews") ;
        return;
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> EditeReview (int reviewid , double rating ,  String data ) async {
    final url = Uri.parse(
        "$Url/reviews/$reviewid");

    try {
      var   headers =  {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.put(url , headers: headers ,body: {
        "review" : data ,
        "rating" : rating.toString(),
      });
      if(responce.body == "couldn't find the review"){
        print("np reviews");
        throw HttpException("soso");
      }
      final exctracteddatat = json.decode(responce.body)  ;
      print(exctracteddatat.toString());

      if(exctracteddatat == null ){
        print("no Reviews") ;
        return;
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> DelleteReview (int reviewId  ) async {
    final url = Uri.parse(
        "$Url/reviews/$reviewId");

    try {
      var   headers =  {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $authToken',
      };
      final responce = await http.delete(url , headers: headers ,);
      if(responce.body == "couldn't find the review"){
        print("np reviews");
        throw HttpException("soso");
      }

      if(responce.body == "Review Deleted"){
        //  reviews.removeWhere((element) => element.id == reviewId);
        print("done deleted");
        return;
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}