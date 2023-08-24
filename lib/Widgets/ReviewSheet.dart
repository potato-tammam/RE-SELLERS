import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/teanslations/locale_Keys.g.dart';
import '../Models/http_Exception.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/Reviews_Providers.dart';

class ReviewSheet extends StatefulWidget {
  final int revid;

  final int userid;

  const ReviewSheet({Key? key, required this.userid, required this.revid})
      : super(key: key);

  @override
  State<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<ReviewSheet> {
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
  TextEditingController revController = TextEditingController();
  double rating = 0;

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
              LocaleKeys.addrevhere.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: revController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.urreview.tr(),
                  border: OutlineInputBorder(),
                  hintText:  LocaleKeys.revhint.tr(),
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
              Text(
               LocaleKeys.revratingadd.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (r) {
                  setState(() {
                    rating = r;
                  });

                  print(r);
                  print(rating);
                },
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Consumer<Reviews>(
                  builder: (ctx, rev, _) => ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size.square(50)),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.green,
                      ),
                    ),
                    onPressed: () async {
                      if (widget.revid == 0) {
                        print("add");
                        try {
                          await rev.AddReview(
                              widget.userid, rating, revController.text);
                          await rev.GetMyReviewOnThisUser(widget.userid);
                          await rev.GetUserReviews(widget.userid);
                          Navigator.pop(context);
                        } on HttpException catch (error) {
                          if (error.message.toString().contains("this u")) {
                            print(error.toString());
                            _showErrorDialog("You can not review yourself");
                          }
                        } catch (error) {
                          print(error.toString());
                        }
                      } else {
                        print("dellet");
                        await rev.EditeReview(
                            widget.revid, rating, revController.text);
                        await rev.GetMyReviewOnThisUser(widget.userid);
                        await rev.GetUserReviews(widget.userid);
                        Navigator.pop(context);
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
