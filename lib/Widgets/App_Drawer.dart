
import 'package:flutter/material.dart';
import 'package:shop_app/Models/Custome_rout.dart';
import 'package:shop_app/Screens/Orders_Screen.dart';
import 'package:shop_app/Screens/Settings%20Screen.dart';
import 'package:shop_app/Screens/User_Products_Screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/User_Profile.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shop_app/teanslations/locale_Keys.g.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(LocaleKeys.drawertitle.tr()),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            tileColor: Theme.of(context).drawerTheme.backgroundColor,
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text(LocaleKeys.drawershope.tr()),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            tileColor: Theme.of(context).drawerTheme.backgroundColor,
            leading: Icon(Icons.payments_outlined),
            title: Text(LocaleKeys.drawerOrders.tr()),
            onTap: (){
             // Navigator.of(context).pushReplacementNamed(OrdersScreen.routname);
              Navigator.of(context).pushReplacement(CustomRoute(widgetBuilder: (ctx)=>OrdersScreen() ));
            },
          ),
          Divider(),
          ListTile(
            tileColor: Theme.of(context).drawerTheme.backgroundColor,
            leading: Icon(Icons.edit_note),
            title: Text(LocaleKeys.drawerManageProducts.tr()),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            tileColor: Theme.of(context).drawerTheme.backgroundColor,
            leading: Icon(Icons.account_circle_outlined),
            title: Text(LocaleKeys.drawerProfile.tr()),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            tileColor: Theme.of(context).drawerTheme.backgroundColor,
            leading: Icon(Icons.settings),
            title: Text(LocaleKeys.sittings.tr()),
            onTap: (){
              Navigator.of(context).pushReplacement(CustomRoute(widgetBuilder: (ctx)=>SettingsScreen() ));
            },
          ),
          Divider(),
           SizedBox(height: 175,),
           Divider(),
          ListTile(
            tileColor: Theme.of(context).drawerTheme.backgroundColor,
            leading: Icon(Icons.logout_sharp),
            title: Text(LocaleKeys.drawerlogout.tr(),style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context ,listen: false).Logout();
            },
          ),
        ],
      ),
    );
  }
}
