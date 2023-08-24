import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app/Widgets/App_Drawer.dart';
import 'package:provider/provider.dart';
import '../Models/User.dart';
import '../Widgets/ListTle_Item.dart';
import '../Widgets/Main_Button.dart';
import '../Widgets/Reviews_list.dart';
import '../core/color.dart';
import '../providers/Profile_Provider.dart';
import '../providers/Reviews_Providers.dart';
import '../teanslations/locale_Keys.g.dart';
import 'User_Products_Screen.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/ProfileScreen";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  // User? u;

  Map<String?, String?> _profiledata = {
    'email': "u?.email",
    'phone': "u?.phone",
    'address': "",
    'items': "",
    'name': "soso",
    "lastname": " ",
    "itemsold": "",
    "rating": "",
  };

  TextEditingController valueCon = TextEditingController();
  var _selectedIndex = 0;
  bool _ischanged = false;
  bool _isloading = false;
  bool _isinit = true;

  void initState() {
    _ischanged = false;
    _selectedIndex = 0;

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    try{
      if (_isinit) {
        setState(() {
          _isloading = true;
        });

        await Provider.of<Profile>(context).GetMyProfile().then((u) async {
          await Provider.of<Reviews>(context,listen: false).GetMyReviews();
          setState(() {
            _profiledata = {
              'email': u?.email,
              'phone': u?.phone,
              'address': u?.address,
              'items': u?.itemsInStore.toString(),
              'name': u?.name,
              "lastname": u?.lastName,
              "itemsold": u?.numberOfSoldItems.toString(),
              "rating": u?.currentRating.toString(),
            };

            _isloading = false;
            // _selectedIndex = 0 ;
          });
          print("1");
        });
      }

      _isinit = false;
    }catch(error){
      print(error);
    }

    super.didChangeDependencies();
  }

  void _showdialog(BuildContext context, String value, int x) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Update your $value : "),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: valueCon,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                onSubmitted: (newval) {
                  setState(() {
                    valueCon.text = newval;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Input Your New $value",
                ),

                // onChanged: (text){
                //   controller.text = text ;
                // },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (x == 1) {
                  setState(() {
                    _profiledata["phone"] = valueCon.text;
                    valueCon.clear();
                    _ischanged = true;
                  });
                }
                if (x == 2) {
                  setState(() {
                    _profiledata["address"] = valueCon.text;
                    valueCon.clear();
                    _ischanged = true;
                  });
                }
                if (x == 3) {
                  setState(() {
                    _profiledata["email"] = valueCon.text;
                    valueCon.clear();
                    _ischanged = true;
                  });
                }
                Navigator.of(ctx).pop();
              },
              child: const Text("Confirm")),
          TextButton(
              onPressed: () {
                setState(() {
                  valueCon.clear();
                });
                Navigator.of(ctx).pop();
              },
              child: const Text("Cancel")),
        ],
      ),
    );
  }


  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.urprofiletilte.tr()),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
     // backgroundColor: grayBG,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,

        selectedItemColor: Theme.of(context).accentColor,
       elevation: 10,

        onTap: (index) {
          if (index == 0) {
            setState(() {
              _selectedIndex = index;
            });

            //  print(_selectedIndex);
          }
          if (index == 1) {
            setState(() {
              _selectedIndex = index;
            });

            print(_selectedIndex);
          }



          print(_selectedIndex);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label:LocaleKeys.profnav.tr()),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review_outlined),
            label:LocaleKeys.revnav.tr(),
          ),
        ],
      ),
      body:  _isloading
          ? Center(child: CircularProgressIndicator())
          : Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 750,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: _selectedIndex == 1
              ? Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Theme.of(context).accentColor.withOpacity(0.5),
                    child: Text(
                      "${_profiledata["name"]?[0]}",
                      style:
                      TextStyle(color: whiteText, fontSize: 45),
                    ),
                    // backgroundImage: AssetImage('assets/images/user.JPG'),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          tileColor: Theme.of(context).scaffoldBackgroundColor,
                          title: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor.withOpacity(0.5),
                              borderRadius:
                              BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              "${_profiledata["name"]} ${_profiledata["lastname"]}",
                              style: TextStyle(
                                  color: whiteText, fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.itemssold.tr(),
                              style: TextStyle(
                                  color: whiteText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _profiledata["itemsold"].toString(),
                              // " u?.numberOfSoldItems.toString() as String",
                              style: TextStyle(
                                color: whiteText,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.ratingnow.tr(),
                              style: TextStyle(
                                  color: whiteText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${_profiledata['rating'].toString()}/ 5 ",
                              // "u?.currentRating.toString() as String",
                              style: TextStyle(
                                  color: whiteText, fontSize: 20),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Divider(thickness: 4),
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black87, width: 1)),
                height: 400,
                child: ReviewsList(),
              ),
            ],
          )
              : Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Theme.of(context).accentColor.withOpacity(0.5),
                    child: Text(
                      "${_profiledata["name"]?[0]}",
                      style:
                      TextStyle(color: whiteText, fontSize: 45),
                    ),
                    // backgroundImage: AssetImage('assets/images/user.JPG'),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          tileColor: Theme.of(context).scaffoldBackgroundColor,
                          title: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor.withOpacity(0.5),
                              borderRadius:
                              BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              "${_profiledata["name"]} ${_profiledata["lastname"]}",
                              style: TextStyle(
                                  color: whiteText, fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.itemssold.tr(),
                              style: TextStyle(
                                  color: whiteText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _profiledata['itemsold'].toString(),
                              //" u?.numberOfSoldItems.toString() as String",
                              style: TextStyle(
                                color: whiteText,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.ratingnow.tr(),
                              style: TextStyle(
                                  color: whiteText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${_profiledata['rating'].toString()}/ 5 ",
                              //" u?.currentRating.toString() as String" ,
                              style: TextStyle(
                                  color: whiteText, fontSize: 20),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Divider(thickness: 4),
              const SizedBox(height: 20),
              ListTileItemProfile(LocaleKeys.itemsinstore.tr(),
                  _profiledata['items']!, Icons.person, () {
                    Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
                  }),
              const SizedBox(height: 20),
              ListTileItemProfile(
                  LocaleKeys.phone.tr(), _profiledata['phone']!, Icons.phone, () {
                _showdialog(context, "phone", 1);
              }),
              const SizedBox(height: 20),
              ListTileItemProfile(LocaleKeys.address.tr(),
                  _profiledata['address']!, Icons.location_on, () {
                    _showdialog(context, "address", 2);
                  }),
              const SizedBox(height: 20),
              ListTileItemProfile(
                LocaleKeys.email.tr(),
                _profiledata['email']!,
                Icons.mail,
                    () {
                  _showdialog(context, "email", 3);
                },
              ),
              const SizedBox(
                height: 25,
              ),
              _ischanged
                  ? Consumer<Profile>(
                builder: (ctx, pro, _) => SizedBox(
                  width: double.infinity,
                  child: Mainbutton(
                    onTap: () async {
                      setState(() {
                        _isloading = true ;
                      });
                      await pro.EditMyProfile(User(
                        name: _profiledata["name"],
                        lastName: _profiledata["lastname"],
                        phone: _profiledata["phone"] ,
                        address: _profiledata["address"],
                      )).then((_) {
                        setState(() {
                          _ischanged = false ;
                          _isloading = false;
                        });
                      }
                      );
                    },
                    text: LocaleKeys.confirmchanges.tr(),
                    btnColor: Theme.of(context).buttonColor,
                  ),
                ),
              )
                  : SizedBox(
                height: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

