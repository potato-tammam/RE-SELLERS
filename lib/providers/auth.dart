import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/http_Exception.dart';
import '../core/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;


  bool get IsAuth {
    return token != null;
  }


  String? get userid {
    return _userId;
  }


  String? get token {
    return _token;
  }


  Future<void> LogIn(String? email, String? password) async {

    final url = Uri.parse(
        "$Url/login");
  var  headers= {
      'Accept': 'application/json',
    'Content-Type': 'application/x-www-form-urlencoded'
    };
    try {
      final response = await http.post(url,
          body:  {
            'email': email,
            'password': password,
          } ,headers: headers);
      if (response.statusCode > 400) {
        throw HttpException("Error Accured");
      }
      final responsedata = json.decode(response.body);
      print(responsedata);

      _token = responsedata['token'];
      print(_token);
      _userId = responsedata['user']['id'].toString();
      print(_userId);

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userauthdata = json.encode({
        'token': _token,
        'userId': _userId,
      });
       prefs.setString("userdata", userauthdata);
    } catch (error) {
      throw error;
    }
  }

  Future<void> SignUp(String? name,String? lastname,String? email, String? password , String? passwordconfirmation,String phone , String address) async {
    final url = Uri.parse('$Url/register');
    var body =
    {
      'name': name,
      'last_name': lastname,
      'email': email,
      'password': password,
      'password_confirmation': passwordconfirmation,
      'phone' : phone ,
      'address' : address ,
    };

    //print(body);
    try {
      final response = await http.post(url,
        body: body,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded'
        },

      );
      final responsedata = json.decode(response.body);
      print(responsedata);
      if (responsedata["error"] != null) {
        throw HttpException(responsedata["error"]["message"]);
      }
      _token = responsedata['token'];
      print(_token);
      _userId = responsedata['user']['id'].toString();
      print(_userId);

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
       final userauthdata = json.encode({
         'token': _token,
         'userId': _userId,
       });
      prefs.setString("userdata", userauthdata);

    } catch (error) {
      throw error;
    }
  }

  Future<bool?> TryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userdata')){
      return false;
    }
    final extractedData =json.decode(prefs.getString("userdata") as String) as Map <String,dynamic> ;
    _token = extractedData['token'];
    _userId = extractedData['userId'];

    notifyListeners();


    return true;

  }



  Future<void> Logout() async{
    _token = null;
    _userId = null;

    notifyListeners();
    final prefs =  await SharedPreferences.getInstance();
     prefs.clear();
  }


}
