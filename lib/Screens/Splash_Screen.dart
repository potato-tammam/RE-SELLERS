import 'package:flutter/material.dart';
import 'package:shop_app/teanslations/locale_Keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10,),
        Center(
          child: Text(LocaleKeys.loading.tr()),
        ),
          SizedBox(height: 10,),
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
