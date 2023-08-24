import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Products_provider.dart';
import 'package:shop_app/teanslations/locale_Keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
class TapBar extends StatefulWidget {
  const TapBar({Key? key}) : super(key: key);

  @override
  State<TapBar> createState() => _TapBarState();
}

class _TapBarState extends State<TapBar> {
  List<String> items = [
    LocaleKeys.home.tr(),
    LocaleKeys.clothes.tr(),
    LocaleKeys.tools.tr(),
    LocaleKeys.kitchenUtilities.tr(),
    LocaleKeys.furniture.tr(),
  ];

  int current  = 0;
 @override

  @override
  Widget build(BuildContext context) {
var prod = Provider.of<Products>(context);
    current  =  prod.categoryid ;
    return Container(
      width: 600,
      height: 60,
      margin: const EdgeInsets.all(5),
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    Consumer<Products>(
                      builder : (ctx,data , _ )=> GestureDetector(
                        onTap: () {
                          setState(() {
                            current = index;
                          });
                          data.category = index ;
                          print(data.categoryid.toString());
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.all(5),
                          width: 65,
                          height: 45,
                          decoration: BoxDecoration(
                            color: current == index ? Colors.white70 : Colors.white54,
                            borderRadius: current == index
                                ? BorderRadius.circular(15)
                                : BorderRadius.circular(10),
                            border: current == index
                                ? Border.all(
                                    color: Theme.of(context).accentColor,
                                    width: 2)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              items[index],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                  color: current == index
                                      ? Colors.black
                                      : Theme.of(context).buttonColor),
                              textAlign: TextAlign.center,
                            ),

                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: current == index,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            shape: BoxShape.circle),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ]),
    );
  }
}
