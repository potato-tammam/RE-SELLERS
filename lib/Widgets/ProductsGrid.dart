
import 'package:flutter/material.dart';

import '../providers/Products_provider.dart';
import 'Product_item.dart';
import 'package:provider/provider.dart';
class ProductsGrid extends StatelessWidget {
final bool showfavs ;
ProductsGrid(this.showfavs);

  @override
  Widget build(BuildContext context) {
   final ProductsData =  Provider.of<Products>(context) ;
   final products = showfavs? ProductsData.FavoritItems : ProductsData.SortedByCategory;
    return GridView.builder(
    physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2 ,
        childAspectRatio: 1.1 ,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx,index){
        return ChangeNotifierProvider.value(
         // create: (c)=> products[index],
          value: products[index],
          child: ProductItem(
            //id: products[index].id,
            // title: products[index].title,
            // imageUrl: products[index].imageUrl,
            // price:products[index].price,
          ),
        );

      },
    );
  }
}