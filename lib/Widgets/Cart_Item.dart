
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/teanslations/locale_Keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/Cart_Details.dart';
class CartItemW extends StatelessWidget {
  final String id ;
  final String prodId ;

  final String title ;
    final double price;
    final int quantity ;

  const CartItemW({Key? key,
   required this.id,
    required this.prodId,
    required  this.title,
    required  this.price,
    required this.quantity}) : super(key: key);



  @override
  Widget build(BuildContext context) {
  var   _total = quantity * price ; 
  return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_sweep,
          size: 40,

        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin:  EdgeInsets.symmetric(horizontal: 15 ,vertical: 4),
      ),
        confirmDismiss: (direction) {
      return showDialog(context: context, builder: (ctx)=>AlertDialog(
        title: Text (LocaleKeys.sure.tr() ,textAlign: TextAlign.center,),
        content: Text(LocaleKeys.deletconf.tr()),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(ctx).pop(true) ;

                }, child: Text( LocaleKeys.yes.tr())),
            TextButton(
                onPressed: (){
              Navigator.of(ctx).pop(false) ;
            }, child: Text( LocaleKeys.no.tr())),
          ],
        ) ,
        );
        },
      onDismissed: (direction){
        Provider.of<Cart>(context , listen: false).RemoveItem(prodId);
      },

      child: Card(
        color: Color.fromRGBO(149, 206, 179, 1.0),
        margin: EdgeInsets.symmetric(horizontal: 15 ,vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            tileColor:Color.fromRGBO(149, 206, 179, 1.0),
            leading: CircleAvatar(child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                  child: Text("\$ ${ price}" , style: TextStyle(
                    fontSize: 15 ,
                  ),)),
            ),),
            title: Text(title),
            subtitle: Text("${LocaleKeys.total.tr()} ${_total.toStringAsFixed(2)} " , ),
            trailing: Text("$quantity X "),
          ),
          ),
        ),
    );

  }
}
