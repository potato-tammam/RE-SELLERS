import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:shop_app/Models/Comment.dart';
import 'package:shop_app/Screens/Profile_To_Users.dart';
import 'package:shop_app/Widgets/CommentSheet.dart';
import 'package:shop_app/Widgets/Comments_List.dart';

import 'package:shop_app/core/color.dart';
import 'package:shop_app/providers/Comments_Provider.dart';
import 'package:shop_app/providers/Products_provider.dart';

import '../Models/Custome_rout.dart';
import '../providers/Cart_Details.dart';
import '../teanslations/locale_Keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routename = "/product-details";

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  void showBottomsheet(BuildContext context, int comid) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Container(
              height: ((MediaQuery.of(context).size.height) / 3) + 125,
              child: CommentSheet(
                  comid: comid,
                  prodid: int.parse(
                      ModalRoute.of(context)?.settings.arguments as String)));
        });
  }

  bool _isloading = true;

  @override
  void didChangeDependencies() async {
    await Provider.of<Comments>(context, listen: false).GetAllComments(
        int.parse(ModalRoute.of(context)?.settings.arguments as String));
    await Provider.of<Comments>(context, listen: false)
        .GetMyCommentOnThisProduct(
            int.parse(ModalRoute.of(context)?.settings.arguments as String))
        .then((_) {
      setState(() {
        _isloading = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final category = [
      'None',
      'Clothes',
      'Kitchen Utilities',
      "Furniture",
      "Tools",
    ];
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loaddedProduct =
        Provider.of<Products>(context, listen: false).FindById(productId);

    // Provider.of<Comments>(context)
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loaddedProduct.title),
      // ),

      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Container(
                      color: Colors.white70,
                      child: Text(
                        loaddedProduct.title,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    background: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        child: Hero(
                            tag: loaddedProduct.id,
                            child: Image.network(
                              loaddedProduct.imageUrl,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Consumer<Products>(builder: (context, prod, _) {
                              return IconButton(
                                onPressed: () async {
                                  await prod.SetFavorit(
                                      loaddedProduct.isFavorite,
                                      loaddedProduct.id);
                                },
                                icon: Icon(loaddedProduct.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_outline),
                                color: Theme.of(context).accentColor,
                              );
                            }),
                            Text(
                              "\$ ${loaddedProduct.price}",
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).accentColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add_shopping_cart_outlined,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () {
                                try{
                                  if (cart.items.containsKey(productId)) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                        Text(LocaleKeys.itemtwiceadded.tr()),
                                        duration: const Duration(seconds: 2),
                                        action: SnackBarAction(
                                          label: LocaleKeys.ok.tr(),
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    cart.AddItem(productId, loaddedProduct.product_creator_id.toString() , loaddedProduct.title,
                                        loaddedProduct.price);
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:  Text(
                                            LocaleKeys.itemaddedtocart.tr()),
                                        duration: const Duration(seconds: 2),
                                        action: SnackBarAction(
                                          label: LocaleKeys.undo.tr(),
                                          onPressed: () {
                                            cart.removSingleItem(productId);
                                          },
                                        ),
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        color: Theme.of(context).accentColor,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          LocaleKeys.overview.tr(),
                          style: TextStyle(
                              fontSize: 30,
                              color: whiteText,
                              fontWeight: FontWeight.bold),

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${LocaleKeys.description.tr()} : ",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: whiteText,
                                        fontWeight: FontWeight
                                            .bold),   overflow: TextOverflow.ellipsis ,
                                  ),
                                  Text(
                                    "${loaddedProduct.description} ",
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: whiteText,

                                      fontSize: 15,
                                        overflow: TextOverflow.ellipsis ,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${LocaleKeys.categorytitle.tr()} : ",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: whiteText,
                                        fontWeight: FontWeight
                                            .bold),   overflow: TextOverflow.ellipsis ,
                                  ),
                                  Text(
                                    category[int.parse(loaddedProduct.categoryId
                                            .toString())]
                                        .toString(),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: whiteText,
                                      fontSize: 15,
                                        overflow: TextOverflow.ellipsis ,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${LocaleKeys.condition.tr()} : ",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: whiteText,
                                        fontWeight: FontWeight
                                            .bold),
                                     overflow: TextOverflow.ellipsis ,
                                  ),
                                  Text(
                                    "${loaddedProduct.condition} ",
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: whiteText,
                                      fontSize: 15,
                                        overflow: TextOverflow.ellipsis ,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).accentColor,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              LocaleKeys.createdby.tr(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: whiteText),
                              textAlign: TextAlign.left,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(CustomRoute(
                                      widgetBuilder: (ctx) =>
                                          ProfileForUsersScreen(
                                              id: int.parse(loaddedProduct
                                                  .product_creator_id
                                                  .toString()))));
                                },
                                child: Text(
                                  loaddedProduct.creator_name.toString(),
                                  overflow: TextOverflow.ellipsis ,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: whiteText),
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).accentColor,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          LocaleKeys.comments.tr(),
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: whiteText),

                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black87, width: 1)),
                        height: 350,
                        child: CommentList(),
                      ),
                      Consumer<Comments>(
                        builder: (ctx, com, _) => com.comment != null
                            ? Column(
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    LocaleKeys.urcomment.tr(),
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70),
                                    textAlign: TextAlign.left,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 6),
                                    decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(5),
                                        backgroundBlendMode: BlendMode.hue,
                                        border: Border.all(
                                            color: Colors.greenAccent
                                                .withOpacity(0.2),
                                            width: 0.1)),
                                    child: ListTile(
                                      style: ListTileStyle.list,
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            Color.fromRGBO(43, 43, 131, 0.1),
                                        radius: 30,
                                        child: Text(
                                          "${com.comment?.name?[0]} ",
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                      title: Text(
                                        "${com.comment?.name} ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      subtitle: Text(
                                        "${com.comment?.data} ",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      contentPadding: EdgeInsets.all(8),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       Text(LocaleKeys.editecomment.tr()),
                                      IconButton(
                                          color: Colors.white70,
                                          iconSize: 30,
                                          onPressed: () {
                                            showBottomsheet(
                                                ctx, com.comment!.id!);
                                          },
                                          icon: Icon(Icons.edit_note_rounded)),
                                      SizedBox(
                                        width: 20,
                                      ),
                                     Text(LocaleKeys.deletecomment.tr()),
                                      IconButton(
                                        color: Colors.white70,
                                        iconSize: 30,
                                        onPressed: () async {
                                          setState(() {
                                            _isloading = true;
                                          });
                                          await com.DelleteComment(
                                                  com.comment!.id!,
                                                  int.parse(productId))
                                              .then((_) async {
                                            await com.GetAllComments(
                                                int.parse(productId));
                                            await com.GetMyCommentOnThisProduct(
                                                int.parse(productId));
                                          });
                                          setState(() {
                                            _isloading = false;
                                          });
                                        },
                                        icon:
                                            Icon(Icons.delete_forever_rounded),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    LocaleKeys.addcomment.tr(),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      showBottomsheet(context, 0);
                                    },
                                    child: Icon(Icons.add),
                                  )
                                ],
                              ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
