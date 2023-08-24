import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:provider/provider.dart';

import '../providers/Reviews_Providers.dart';

class ReviewsList extends StatelessWidget {
  const ReviewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rev = Provider.of<Reviews>(context);
    final reviews = rev.reviews;

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) => Container(

        margin: EdgeInsets.symmetric(vertical: 4 ,horizontal: 6),
        decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(5),
            backgroundBlendMode: BlendMode.hue,
            border: Border.all(color: Colors.greenAccent.withOpacity(0.2) , width: 0.1)
        ),
        child: ListTile(
          style:  ListTileStyle.drawer ,

          leading: CircleAvatar(
            backgroundColor: Color.fromRGBO(43, 43, 131, 0.1),
            radius: 30,
            child: Text(
              reviews[index].name[0],
              overflow: TextOverflow.clip,

            ),
          ),
          title: Text(reviews[index].name ,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),),
          trailing:  RatingBar.builder(
            itemSize: 20,
            initialRating: reviews[index].rating,
            ignoreGestures: true,
            updateOnDrag: false,
            tapOnlyMode: false,
            allowHalfRating: true,
            onRatingUpdate: (double) {},
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
              size: 5,
            ),
          ),
          subtitle:Text( reviews[index].data! ,overflow: TextOverflow.ellipsis, ),
          contentPadding: EdgeInsets.all(8),

        ),
      ),
    );
  }
}