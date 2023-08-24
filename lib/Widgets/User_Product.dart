import 'package:flutter/material.dart';
import 'package:shop_app/Screens/Edite_Products_Screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Products_provider.dart';

class UserProduct extends StatelessWidget {
  final String id;

  final String title;

  final String imageUrl;
  final String state ;
  const UserProduct(
      {Key? key,required this.state ,  required this.id, required this.title, required this.imageUrl })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scafoldmes =  ScaffoldMessenger.of(context);
    return ListTile(
      tileColor: state == "active" ?
        Color.fromRGBO(100, 155, 107, 1.0):
        Color.fromRGBO(231, 195, 98, 1.0),
      textColor: Colors.white,
      title: Text(title),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditeProductsScreen.routename, arguments: id);
                },
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () async {
                  try {
                   await Provider.of<Products>(context, listen: false)
                        .DeletProduct(id);
                  } catch (error) {
                   scafoldmes.showSnackBar(
                        SnackBar(content: Text("Failed to delete Item ! " , textAlign: TextAlign.center,)));
                  }
                },
                color: Theme.of(context).errorColor,
                icon: Icon(Icons.delete_outlined)),
          ],
        ),
      ),
    );
  }
}
