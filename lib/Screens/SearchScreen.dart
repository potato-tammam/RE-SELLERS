
import 'package:flutter/material.dart';
import 'package:shop_app/core/color.dart';
import '../providers/Product.dart';
import '../providers/Products_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../teanslations/locale_Keys.g.dart';
import 'Product_Details_Screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> searchList = [];
  List<Product> items = [];
  bool _by_price = false ;
  String? init  ;
  @override
  void didChangeDependencies() {
    final ProductsData = Provider.of<Products>(context);
    items = ProductsData.items;
    searchList = List.from(items);
    super.didChangeDependencies();
  }

  void updatesearchList(String value) {
    setState(() {
      searchList = items
          .where((element) =>
              element.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
  void updatesearchList2(String v) {
    int initvalue = 10 ;
    var rang ;

     try {
       initvalue =  int.parse(v);
       rang  = RangeValues(initvalue.toDouble()-10, initvalue.toDouble()+10);
     } on Exception catch (e) {
       if(rang == null){
         return;
       } else{
         initvalue = 10 ;
         rang  = RangeValues(initvalue.toDouble()-20, initvalue.toDouble()+20);
       }

     }

   print(rang.toString());
    setState(() {
      searchList = items
          .where((element) =>
                     element.price > rang.start && element.price < rang.end   )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: DropdownButton(

              icon: Icon(Icons.keyboard_double_arrow_down_outlined),
                iconSize: 25,
                items: [
              DropdownMenuItem(child: Text(LocaleKeys.searchbytitle.tr()) , value: "By title",),
              DropdownMenuItem(child: Text(LocaleKeys.searchbyprice.tr()) , value: "By Price",),
            ], onChanged: (v){
              if(v == "By Price"){
                setState(() {
                  _by_price = true;

                });
              }else{
                setState(() {
                  _by_price = false;

                });
              }
            },
            ),
          ),
        ],
        title: Text(
          LocaleKeys.searchtitle.tr(),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10 ,right: 10,left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              onChanged: (value) =>_by_price ?updatesearchList2(value.toString()) :updatesearchList(value),
              style: TextStyle(color: Colors.white),
              cursorColor: Theme.of(context).accentColor,
              decoration: InputDecoration(
                filled: true,
                  fillColor: Colors.grey,
                  hintText: "eg : White shoes ... ",
                  suffixIcon: Icon(Icons.search),
                  suffixIconColor: whiteText),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: searchList.length == 0
                ? Center(
                    child: Text(
                      LocaleKeys.noresult.tr(),
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  )
                : Container(
                    height: 350,
                    margin: EdgeInsets.all(10),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      itemCount: searchList.length,
                      itemBuilder: (context, index) => Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: ListTile(
                            tileColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                            ),
                            contentPadding: EdgeInsets.all(8),
                            title: Text(searchList[index].title),
                            subtitle:
                                Text(searchList[index].price.toString()),
                            trailing: Consumer<Products>(
                                builder: (context, prod, _) {
                              return IconButton(
                                onPressed: () async {
                                  await prod.SetFavorit(
                                      searchList[index].isFavorite,
                                      searchList[index].id);
                                },
                                icon: Icon(searchList[index].isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_outline),
                                color: Theme.of(context).accentColor,
                              );
                            }),
                            leading: ClipRRect(
                              child: Container(
                                width: 80,
                                height: 100,
                                child: Image.network(
                                  searchList[index].imageUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                ProductDetailScreen.routename,
                                arguments: searchList[index].id,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
