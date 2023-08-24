import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/color.dart';
import '../core/text_style.dart';

Widget textFild({
  required String hintTxt,
  required Icon icon,
  required TextEditingController controller,
  bool isObs = false,
  TextInputType? keyBordType,
 required BuildContext ctx,
}) {
  return Container(
    height: 70.0,
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    margin: EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 10.0,
    ),
    decoration: BoxDecoration(
      color: Theme.of(ctx).listTileTheme.tileColor,
      borderRadius: BorderRadius.circular(20.0),
      border: Border(),

    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 270.0,
          child: TextField(
            controller: controller ,
            textAlignVertical: TextAlignVertical.center,
            obscureText: isObs,
            keyboardType: keyBordType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintTxt,
              hintStyle: hintStyle,
            ),
            style: headline2,
            // onChanged: (text){
            //   controller.text = text ;
            // },
          ),
        ),
        icon
      ],
    ),
  );
}
