import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/Comments_Provider.dart';
import '../teanslations/locale_Keys.g.dart';



class CommentSheet extends StatefulWidget {
  final int comid;

  final int prodid;

  const CommentSheet({Key? key, required this.prodid, required this.comid})
      : super(key: key);

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  void _showErrorDialog(String errormessage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(LocaleKeys.anerroraccured.tr()),
          content: Text(errormessage),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(LocaleKeys.ok.tr()))
          ],
        ));
  }
  @override
  TextEditingController  revController = TextEditingController();


  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                LocaleKeys.addcomhere.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: revController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.urcomment.tr(),
                  border: OutlineInputBorder(),
                  hintText: LocaleKeys.commenthint.tr(),
                ),
                keyboardType: TextInputType.text,
                minLines: 1,
                maxLines: 4,
                onSubmitted: (value) {
                  setState(() {
                    revController.text = value;
                  });
                  print(revController.text);
                },
              ),

              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Consumer<Comments>(
                  builder: (ctx, com, _) => ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size.square(50)),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.green,
                      ),
                    ),
                    onPressed: () async {
                      if (widget.comid == 0) {
                        print("add");
                        try{
                          await com.AddComment( revController.text , widget.prodid,);
                          await com.GetMyCommentOnThisProduct(widget.prodid);
                          await com.GetAllComments(widget.prodid);
                          Navigator.pop( context );

                        }catch(error){
                          print(error.toString());
                        }

                      } else {
                        print("edite");

                        try{
                          await com.EditeComment(
                              widget.comid, widget.prodid, revController.text);
                          await com.GetMyCommentOnThisProduct(widget.prodid);
                          await com.GetAllComments(widget.prodid);
                          Navigator.pop( context );
                          // Navigator.pushAndRemoveUntil( context,  MaterialPageRoute(
                          //     builder: (builder) =>
                          //         ProfileForUsersScreen(id: widget.prodid)) , (route)=>false );
                        }catch(error){
                          print(error.toString());
                        }

                      }

                    },
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
