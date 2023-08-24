import 'package:flutter/material.dart';

import '../core/color.dart';

ListTileItemProfile(String title, String subtitle, IconData iconData, VoidCallback onpressed) {
  return Container(
    decoration: BoxDecoration(

       // borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 3),
              color: Colors.white70.withOpacity(.1),
              spreadRadius: 1.5,
              blurRadius: 2)
        ]),
    child: ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: whiteText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: grayText,
        ),
      ),
      leading: Icon(
        iconData,
        size: 35,
        color: whiteText.withOpacity(0.5),
      ),
      trailing:IconButton(icon: Icon(Icons.mode_edit_outline_outlined) , color: Colors.grey.shade400 , onPressed: onpressed,),
    ),
  );
}
