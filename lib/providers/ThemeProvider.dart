import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTheme with ChangeNotifier{
  String? _lang ;
  bool? currentmood  =  true;



  bool get isdark{
    if(currentmood == true) {
      return true ;
    }
    return false ;
  }

  void SetTheme(bool isdark )async{
    final prefs = await SharedPreferences.getInstance();
   await prefs.setBool("isdark", isdark);
    currentmood = isdark ;
    notifyListeners();
  }
  intitialize ()async{
    final prefs = await SharedPreferences.getInstance();
     currentmood =  await prefs.getBool("isdark") ?? true ;
      notifyListeners();
  }
}