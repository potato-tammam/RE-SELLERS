import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/User.dart';
import '../core/color.dart';



class Profile with ChangeNotifier {
  String? userid;
  String? authtoken;

  Profile({
    required this.userid,
    required this.authtoken,
  });




  Future<User?> GetMyProfile() async {
    final url = Uri.parse(
        "$Url/auth_profile");
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $authtoken',
    };

    try {
      final responce = await http.get(url, headers: headers);
      final exctracteddatat = json.decode(responce.body);
      print(exctracteddatat.toString());
      if (exctracteddatat == null) {
        print("a7eeh");
        return null;
      }
      notifyListeners();
      return User(
        name: exctracteddatat['name'].toString(),
        lastName: exctracteddatat['last_name'].toString(),
        email: exctracteddatat['email'].toString(),
        address: exctracteddatat['address'].toString(),
        currentRating:exctracteddatat['current_rating'].toString(),
        emailVerifiedAt: exctracteddatat['email_verified_at'].toString(),
        itemsInStore:exctracteddatat['items_in_store'].toString()  ,
        numberOfSoldItems:exctracteddatat['number_of_sold_items'].toString() ,
        phone: exctracteddatat['phone'].toString(),
      );
      // print( this.name);
      // name = exctracteddatat['name'];
      // lastName = exctracteddatat['last_name'];
      // phone = exctracteddatat['phone'];
      // address = exctracteddatat['address'];
      // email = exctracteddatat['email'];
      // emailVerifiedAt = exctracteddatat['email_verified_at'];
      // itemsInStore = exctracteddatat['items_in_store'];
      // numberOfSoldItems = exctracteddatat['number_of_sold_items'];
      // currentRating = exctracteddatat['current_rating'];
      // createdAt = exctracteddatat['created_at'];
      // updatedAt = exctracteddatat['updated_at'];
      //   print(this.name);
      // print(_items[42].title );
      // print(_lastFour.length);
      //

    } catch (error) {
      throw error;
    }
  }

  Future<User?> GetProfile(int id) async {
    final url = Uri.parse(
        "$Url/profile/$id");
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $authtoken',
    };

    try {
      final responce = await http.get(url, headers: headers);
      // print(responce.body);
      final exctracteddatat = json.decode(responce.body);
      // print(exctracteddatat.toString());
      if (exctracteddatat == null) {
        print("a7eeh");
        return null;
      }
      notifyListeners();
      return User(
        name: exctracteddatat['name'].toString(),
        lastName: exctracteddatat['last_name'].toString(),
        email: exctracteddatat['email'].toString(),
        address: exctracteddatat['address'].toString(),
        currentRating:exctracteddatat['current_rating'].toString(),
        emailVerifiedAt: exctracteddatat['email_verified_at'].toString(),
        itemsInStore:exctracteddatat['items_in_store'].toString()  ,
        numberOfSoldItems:exctracteddatat['number_of_sold_items'].toString() ,
        phone: exctracteddatat['phone'].toString(),
        yourself : userid == id.toString() ?  true : false ,
      );


    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> EditMyProfile(User newUser) async {
    final url = Uri.parse(
        "$Url/auth_profile");
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $authtoken',
    };

    try {
      final responce = await http.put(url, headers: headers , body: {
        'name': newUser.name,
        'last_name': newUser.lastName,
        'phone': newUser.phone,
        'address': newUser.address,
        //   'email':newUser.email,
      });
      final exctracteddatat = json.decode(responce.body);
      print(exctracteddatat.toString());
      if (exctracteddatat == null) {
        print("a7eeh");
        return ;
      }

      notifyListeners();



    } catch (error) {
      throw error;
    }
  }



}




