import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Comments_Provider.dart';



class CommentList extends StatelessWidget {
  const CommentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final com = Provider.of<Comments>(context);
    final comments = com.comments;
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: comments.length,
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
              comments[index].name![0],
              overflow: TextOverflow.clip,

            ),
          ),
          trailing: Text(comments[index].userId!.toString() ,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),),
          title: Text(comments[index].name! ,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),),
          subtitle:Text( comments[index].data! ,overflow: TextOverflow.ellipsis, ),
          contentPadding: EdgeInsets.all(8),

        ),
      ),
    );
  }
}