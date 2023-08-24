import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/Edite_Products_Screen.dart';
import 'package:shop_app/Widgets/App_Drawer.dart';
import 'package:shop_app/Widgets/User_Product.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shop_app/teanslations/locale_Keys.g.dart';
import '../providers/Products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-Products';

  Future<void> _refrech(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).FetchMyProducts();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.urproducts.tr()),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditeProductsScreen.routename);
              },
              icon: Icon(Icons.add)),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refrech(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                child:TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1),
                  duration: const Duration(milliseconds: 2500),
                  builder: (context, value, _) => CircularProgressIndicator(
                      color: Theme.of(context).accentColor,
                      strokeWidth: 6,
                      value: value),
                )
            )
                : RefreshIndicator(
                    onRefresh: () => _refrech(context),
                    child: Consumer<Products>(
                      builder: (ctx ,productsdata , _)=>
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: // Text('fiiiiii'),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin:  const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(LocaleKeys.accepted.tr()),
                                        Icon(Icons.circle , color:  Color.fromRGBO(84, 105, 88, 1.0), ),
                                        Text(LocaleKeys.pending.tr()),
                                        Icon(Icons.circle , color:  Color.fromRGBO(
                                            231, 195, 98, 1.0), ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  height: 500,
                                  child: ListView.builder(
                          itemCount: productsdata.useritems.length,
                          itemBuilder: (_, i) => Column(
                                  children: [
                                    UserProduct(
                                        state: productsdata.useritems[i].status.toString(),
                                        id: productsdata.useritems[i].id,
                                        title: productsdata.useritems[i].title,
                                        imageUrl: productsdata.useritems[i].imageUrl),
                                    Divider(
                                      color: Colors.white60,
                                    ),
                                  ],
                          ),
                        ),
                                ),
                              ],
                            ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
