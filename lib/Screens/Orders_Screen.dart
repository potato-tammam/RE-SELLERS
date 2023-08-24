import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Widgets/App_Drawer.dart';
import 'package:shop_app/Widgets/Order_Item.dart';
import 'package:shop_app/providers/Order_Provider.dart';
import 'package:shop_app/teanslations/locale_Keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
class OrdersScreen extends StatefulWidget {
  static const routname = '/OrdersScreen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
   Future? _ordersFuture = null ;
    Future _obtainOrdersFuture(){
      return Provider.of<Order>(context ,listen: false).FetchOrders();
    }
@override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  //  final orderdata = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.urordertitle.tr()),
      ),
      drawer: AppDrawer(),
      body:FutureBuilder(
        future:_ordersFuture,
        builder: (ctx,data){
    if(data.connectionState == ConnectionState.waiting){
      return Center(
          child:TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1),
            duration: const Duration(milliseconds: 2500),
            builder: (context, value, _) => CircularProgressIndicator(
                color: Theme.of(context).accentColor,
                strokeWidth: 6,
                value: value),
          )
      );
    }else{
      if(data.error != null){
       return Center(child: Text(LocaleKeys.anerroraccured.tr()));
      }else{
        return Consumer<Order>(
          builder: (ctx , orderdata ,child) {
          return  Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
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
                    itemCount: orderdata.orders.length,
                    itemBuilder: (ctx, i) => OderItem(
                      order: orderdata.orders[i],
                    ),
                  ),
              ),
            ],
          );
          },
        );

      }
    }
      },
      )   ,
    );
  }
}
