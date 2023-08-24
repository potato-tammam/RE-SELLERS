
import 'package:flutter/material.dart';
import 'package:shop_app/Models/http_Exception.dart';
import 'package:shop_app/Screens/Product_Details_Screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Cart_Details.dart';
import 'package:shop_app/providers/Product.dart';
import 'package:shop_app/providers/auth.dart';

import '../teanslations/locale_Keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductItem extends StatelessWidget {
  // final String id ;
  // final String title ;
  // final String imageUrl ;
  // final double price;
  // const ProductItem({Key? key,required this.id,required this.title,required this.imageUrl ,required this.price}) : super(key: key);
  //
  
  @override
  Widget build(BuildContext context) {
   final prod =  Provider.of<Product>(context , listen: false);
   final cart = Provider.of<Cart>(context );
   final authdata = Provider.of<Auth>(context ,listen: false);
   void _showshite(BuildContext context){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
       content: const  Text("Cant Add Your Own Item ! "),
       duration: const  Duration(seconds: 2),
       action: SnackBarAction(
         label: 'Ok',
         onPressed: (){
           ScaffoldMessenger.of(context).hideCurrentSnackBar();
         },),
     ),
     );
   }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GridTile(
        child: Container(
          color:Theme.of(context).primaryColor,
          padding: const  EdgeInsets.all(1),
          child: GestureDetector(
              child:Hero(
                tag: prod.id,
                child: FadeInImage(
                  placeholder: const AssetImage("assets/images/product-placeholder.png"),
                  image: NetworkImage(prod.imageUrl),
                  fit: BoxFit.cover,
                ),
              ) ,
            onTap: (){
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routename ,
                  arguments: prod.id ,
                );
            },
          ),
        ),
        header:
        GridTileBar(
          subtitle: CircleAvatar(
            radius: 35,
            backgroundColor : Colors.black87,
            child: Text("${prod.price} \$ ",style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
              textAlign: TextAlign.center,
            ),
          ),

        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx,prod ,_ ){
              return IconButton (icon:
              Icon(prod.isFavorite?  Icons.favorite_sharp : Icons.favorite_border),
                color: Theme.of(context).accentColor,
           //     label : child ,
                onPressed: (){
                try{
                  prod.SetFavorit(authdata.token );
                }on HttpException catch(error){
                  if(error.message.contains("wowo") ){
                  _showshite(ctx);
                  }
                  _showshite(ctx);
                }catch(error){
                  _showshite(ctx);
                }

                },
              );
            },
      //      child: Text('this never changes'), things to think  about  !!!!!
          ),
          backgroundColor: Colors.black87,
        title: Text(prod.title ,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,),

          trailing: IconButton (icon:
          Icon(Icons.add_shopping_cart_outlined,
            color: Theme.of(context).accentColor,
          ),
            onPressed: (){
            try{
              if(cart.items.containsKey(prod.id)){
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:   Text(LocaleKeys.itemtwiceadded.tr()),
                  duration: const  Duration(seconds: 2),
                  action: SnackBarAction(
                    label: LocaleKeys.ok.tr(),
                    onPressed: (){
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },),
                ),
                );
              }else{
                cart.AddItem(prod.id,prod.product_creator_id.toString(), prod.title, prod.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:   Text(LocaleKeys.itemaddedtocart.tr()),
                  duration: const  Duration(seconds: 2),
                  action: SnackBarAction(
                    label: LocaleKeys.undo.tr(),
                    onPressed: (){
                      cart.removSingleItem(prod.id);
                    },),
                ),
                );
              }
            }catch(er){
              ScaffoldMessenger.of(context)
                  .hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:  Text(
                      LocaleKeys.cantaddyourown.tr()),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label:  LocaleKeys.ok.tr(),
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            }


            },
          ),
      ),

      ),
    );
  }
}
