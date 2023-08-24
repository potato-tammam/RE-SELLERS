import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/Order_Provider.dart';


class OderItem extends StatefulWidget {
  final OrderItem order;

  const OderItem({Key? key, required this.order}) : super(key: key);

  @override
  State<OderItem> createState() => _OderItemState();
}

class _OderItemState extends State<OderItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(

      duration: Duration(milliseconds: 250),
      height: _isExpanded ?  min(widget.order.OrderItems.length * 20.0 + 150.0, 176.0): 88,
      child: Card(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              tileColor: Color.fromRGBO(84, 105, 88, 1.0),
              title: Text('\$ ${widget.order.total}'),
              subtitle: Text(
                "date"
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: Icon(_isExpanded ? Icons.expand_less_rounded : Icons
                    .expand_more_rounded),
              ),
            ),
             AnimatedContainer(

               duration: Duration(milliseconds: 250),
              color: Color.fromRGBO(149, 206, 179, 1.0),
              padding: EdgeInsets.all(10),
              height:_isExpanded? min(widget.order.OrderItems.length * 20.0 + 60.0, 88.0) : 0,
              child:  ListView(

                physics:BouncingScrollPhysics(),
                children: widget.order.OrderItems.map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.tilte, style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),
                      Text("${e.quantity} X ${e.price}" , style: TextStyle(color: Colors.black , fontSize: 15 ),)
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
