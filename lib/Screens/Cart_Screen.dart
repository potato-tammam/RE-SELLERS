import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Cart_Details.dart';
import 'package:shop_app/Widgets/Cart_Item.dart';
import 'package:shop_app/providers/Order_Provider.dart';
import 'package:shop_app/providers/Products_provider.dart';
import 'package:shop_app/teanslations/locale_Keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
class CartScreen extends StatelessWidget {
  static const routname = "/cartscreen";

  @override
  Widget build(BuildContext context) {
    final cartdata = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.carttitle.tr()),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.total.tr(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$ ${cartdata.ToltalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            ?.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartdata: cartdata),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cartdata.ItemCount,
                  itemBuilder: (ctx, i) {
                    return CartItemW(
                        id: cartdata.items.values.toList()[i].id,
                        prodId: cartdata.items.keys.toList()[i],
                        title: cartdata.items.values.toList()[i].tilte,
                        price: cartdata.items.values.toList()[i].price,
                        quantity: cartdata.items.values.toList()[i].quantity);
                  })),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartdata,
  }) : super(key: key);

  final Cart cartdata;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:(widget.cartdata.ToltalAmount<=0 || _isloading) ? null : ()async {
        setState(() {
          _isloading = true ;
        });
      await  Provider.of<Order>(context, listen: false).addoroder(
            widget.cartdata.items.values.toList(),
            widget.cartdata.ToltalAmount);
    await Provider.of<Products>(context,listen: false).FetchProducts();
      setState(() {
        _isloading =false;
      });
        widget.cartdata.ClearCart();

      },
      child:_isloading? CircularProgressIndicator(): Text(
        LocaleKeys.ordernow.tr(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
