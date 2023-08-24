
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Widgets/Main_Button.dart';
import '../Widgets/ReviewSheet.dart';
import '../Widgets/Reviews_list.dart';
import '../core/color.dart';
import '../providers/Profile_Provider.dart';
import '../providers/Reviews_Providers.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../teanslations/locale_Keys.g.dart';

class ProfileForUsersScreen extends StatefulWidget {
  @override
  final id;

  const ProfileForUsersScreen({Key? key, required this.id}) : super(key: key);
  State<ProfileForUsersScreen> createState() => _ProfileForUsersScreenState(id);
}

class _ProfileForUsersScreenState extends State<ProfileForUsersScreen> {

  bool _hasreview = true ;
  final  int  id;
  _ProfileForUsersScreenState(this.id);
  bool _isloading = false;
  bool _isinit = true;


  void showBottomsheet(BuildContext context, int revid) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Container(
            height: ((MediaQuery.of(context).size.height) / 2) + 125,
            child: ReviewSheet(revid: revid, userid: id),
          );
        });
  }



  Map<String?, String?> _profiledata = {
    'reviewname': "u?.email",
    'reviewrating': "u?.phone",
    'reviewdata': "s",
    'reviewid': "s",
    'name': "soso",
    "lastname": " ",
    "itemsold": "",
    "rating": "",
    "yourself" : "",
  };


@override
  void didChangeDependencies()async {
  if (_isinit) {
    setState(() {
      _isloading = true;
    });
    await Provider.of<Reviews>(context ,listen: false).GetUserReviews(id);
    await Provider.of<Reviews>(context ,listen: false).GetMyReviewOnThisUser(id);
    await Provider.of<Profile>(context ,listen: false).GetProfile(id).then((u) async {
      setState(() {
        _profiledata['name'] = u?.name;
        _profiledata["lastname"] = u?.lastName;
        _profiledata["itemsold"] = u?.numberOfSoldItems.toString();
        _profiledata["rating"] = u?.currentRating.toString();
        _profiledata["yourself"] = u?.yourself.toString();
        print(u?.yourself.toString());
        _isloading = false;
        // _selectedIndex = 0 ;
      });
    });

  }

  _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(

     ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child:_isloading? Center(child: CircularProgressIndicator()): Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 40),
              Row(

                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: greenButton.withOpacity(0.5),
                    child: Text(
                      "${_profiledata["name"]?[0]}",
                      style: TextStyle(color: whiteText, fontSize: 45),
                    ),
                    // backgroundImage: AssetImage('assets/images/user.JPG'),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          ListTile(
                            tileColor: Theme.of(context).scaffoldBackgroundColor,
                            title: Container(
                              decoration: BoxDecoration(
                                color: greenButton.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              child: Text(
                                "${_profiledata["name"]} ${_profiledata["lastname"]}",
                                style: TextStyle(
                                    color: whiteText,
                                    fontSize: 20
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),


                            // trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(LocaleKeys.itemssold.tr(),
                                style: TextStyle(
                                    color: whiteText,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                _profiledata['itemsold'].toString(),
                                style: TextStyle(
                                  color: whiteText,
                                  fontSize: 20,

                                ),
                                textAlign: TextAlign.right,),

                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(LocaleKeys.ratingnow.tr(),
                                style: TextStyle(
                                    color: whiteText,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                "${_profiledata['rating'].toString()}/ 5 ",
                                style: TextStyle(
                                    color: whiteText,
                                    fontSize: 20
                                ),
                                textAlign: TextAlign.right,),

                            ],),
                        ],
                      ),
                    ),

                ],
              ),
              const SizedBox(height: 20),
              Divider(thickness: 4),
              const SizedBox(height: 20),
              Text(
                LocaleKeys.reviews.tr(),
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black87, width: 1)),
                height: 365,
                width: double.infinity,
                child: ReviewsList(),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              Consumer<Reviews>(
                builder: (ctx , rev , _)=> rev.myReview != null ?Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Text(
                      LocaleKeys.urreview.tr(),
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold , color: Colors.white70),
                      textAlign: TextAlign.left,
                    ),
                    Container(

                      margin: EdgeInsets.symmetric(vertical: 4 ,horizontal: 6),
                      decoration: BoxDecoration(
                          color: Colors.white24,

                          borderRadius: BorderRadius.circular(5),
                          backgroundBlendMode: BlendMode.hue,
                          border: Border.all(color: Colors.greenAccent.withOpacity(0.2) , width: 0.1)
                      ),
                      child: ListTile(
                        style:  ListTileStyle.list ,
                        tileColor: Theme.of(context).scaffoldBackgroundColor,
                        leading: CircleAvatar(
                          backgroundColor: Color.fromRGBO(43, 43, 131, 0.1),
                          radius: 30,
                          child: Text(
                            "${rev.myReview?.name[0]}",
                            overflow: TextOverflow.clip,

                          ),
                        ),
                        title: Text("${rev.myReview?.name}" ,style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),),
                        trailing:  RatingBar.builder(
                          itemSize: 20,
                          initialRating: rev.myReview?.rating as double,
                          ignoreGestures: true,
                          updateOnDrag: false,
                          tapOnlyMode: false,
                          onRatingUpdate: (x) {},
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 3,
                          ),
                        ),
                        subtitle:Text( "${rev.myReview?.data}" ,overflow: TextOverflow.ellipsis, ),
                        contentPadding: EdgeInsets.all(8),

                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LocaleKeys.editereview.tr()),
                        IconButton(
                            color: Colors.white70,
                            iconSize: 30,
                            onPressed: (){
                              showBottomsheet(context , rev.myReview!.id);
                            }
                            , icon: Icon(Icons.edit_note_rounded)),
                        SizedBox(width: 20,),
                        Text(LocaleKeys.deletereview.tr()),
                        IconButton(

                          color: Colors.white70,
                          iconSize: 30,
                          onPressed: ()async{
                            setState(() {
                              _isloading = true;
                            });
                            await rev.DelleteReview(rev.myReview!.id)
                                .then((_) async {
                              await rev.GetUserReviews(id);
                              await rev.GetMyReviewOnThisUser(id);
                            });
                            setState(() {
                              _isloading = false;
                            });
                          }, icon: Icon(Icons.delete_forever_rounded),
                        ),
                      ],
                    )
                  ],
                ) : _profiledata["yourself"] == "true" ? SizedBox(height: 10,) : SizedBox(
                  width: double.infinity,
                  child: Mainbutton(
                    onTap: () {
                      setState(() {
                        _isloading = true;
                      });
                      showBottomsheet(context, 0);
                      setState(() {
                        _isloading = false;
                      });
                    },
                    text: LocaleKeys.addreview.tr(),
                    btnColor: Theme.of(context).buttonColor,
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
