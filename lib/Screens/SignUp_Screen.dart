import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/Products_Overview_Screen.dart';
import '../Models/http_Exception.dart';

import 'package:shop_app/providers/auth.dart';
import '../Widgets/Custom_TextField.dart';
import '../Widgets/Main_Button.dart';
import '../core/color.dart';
import '../core/text_style.dart';
import '../teanslations/locale_Keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = "/SignUp";
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController userFName = TextEditingController();
  TextEditingController userLName = TextEditingController();
  TextEditingController userPass = TextEditingController();
  TextEditingController userPassCon = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController userPh = TextEditingController();

  var _isLoading = false;

  void _showErrorDialog(String errormessage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred'),
          content: Text(errormessage),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('OK'))
          ],
        ));
  }
  Future<void> _submit(String fname , String lname , String email , String password ,  String phoneNumber , String address) async {

    setState(() {
      _isLoading =true ;
    });
    try {

      // Sign user up
     await Provider.of<Auth>(context,listen: false).SignUp(fname ,lname,email,password,password,phoneNumber,address);
      //
       Navigator.pushReplacementNamed(context, ProductsOverViewScreen.routeName);
    }
    on HttpException catch (error) {
      var errormessage = " Authentication Failed ";
      if (error.toString().contains("EMAIL_EXISTS")) {
        errormessage = "This email Address is already in use ";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errormessage = "This email Address is Not Valid ";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errormessage = "This Password is very weak try Another ";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errormessage = "Could not find a user with this email  ";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errormessage = "Wrong password try Again ";
      }
      _showErrorDialog(errormessage);
    } catch (error) {
      print(error);
      const errormessage = "Could not authenticate you. please try again";
      _showErrorDialog(errormessage);
    }

    setState(() {
      _isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50.0),
              Text(
                LocaleKeys.creatnewacc.tr(),
                style: headline1,
              ),
              SizedBox(height: 10.0),
              Text(
                LocaleKeys.pls2.tr(),
                style: headline3,
              ),
              SizedBox(height: 60.0),
              textFild(
                controller: userFName,
                icon: Icon(Icons.drive_file_rename_outline,
                  color: grayText.withOpacity(0.3),),
                keyBordType: TextInputType.name,
                hintTxt: LocaleKeys.fname.tr(),
                ctx: context,
              ),

              textFild(
                controller: userLName,
                icon: Icon(Icons.supervised_user_circle_outlined,
                  color: grayText.withOpacity(0.3),),
                keyBordType: TextInputType.name,
                hintTxt: LocaleKeys.Lname.tr(),
                ctx: context,
              ),

              textFild(
                controller: userEmail,
                keyBordType: TextInputType.emailAddress,
                icon: Icon(Icons.email_outlined,
                  color: grayText.withOpacity(0.3),),
                hintTxt: LocaleKeys.email.tr(),
                ctx: context,
              ),
              textFild(
                controller: userPh,
                icon: Icon(Icons.phone,
                  color: grayText.withOpacity(0.3),),
                keyBordType: TextInputType.phone,
                hintTxt: LocaleKeys.phone.tr(),
                ctx: context,
              ),
              textFild(
                controller: userAddress,
                keyBordType: TextInputType.text,
                icon: Icon(Icons.location_on,
                  color: grayText.withOpacity(0.3),),
                hintTxt: LocaleKeys.address.tr(),
                ctx: context,
              ),
              textFild(
                controller: userPass,
                isObs: true,
                icon: Icon(Icons.password_outlined,
                  color: grayText.withOpacity(0.3),),
                hintTxt: LocaleKeys.password.tr(),
                ctx: context,
              ),
              textFild(
                controller: userPassCon,
                isObs: true,
                icon: Icon(Icons.confirmation_num_outlined,
                  color: grayText.withOpacity(0.3),),
                hintTxt: LocaleKeys.conpass.tr(),
                ctx: context,

              ),
              SizedBox(height: 80.0),
              _isLoading? CircularProgressIndicator(): Mainbutton(
                onTap:() {

                  if (userPassCon.text == userPass.text) {
                    _submit(userFName.text.toString(), userLName.text.toString(),
                        userEmail.text.toString(), userPass.text.toString(),
                        userPh.text.toString(),userAddress.text.toString());

                  }
                  else{
                    _showErrorDialog("The password confirmation is not valid");
                  }

                  //  print(userFName.text  + userLName.text + userEmail.text + userPass.text);
                  //  await  Provider.of<Auth>(context,listen: false).SignUp("soso","ahmad", "sosoahmad@gmail.com", "12345678","12345678");
                },
                text: LocaleKeys.signup.tr(),
                btnColor:Theme.of(context).buttonColor,
              ),
              SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: LocaleKeys.acc.tr(),
                      style: headline.copyWith(
                        fontSize: 14.0,
                      ),
                    ),
                    TextSpan(
                      text: LocaleKeys.signin.tr(),
                      style: headlineDot.copyWith(
                        fontSize: 14.0,
                        color: Theme.of(context).buttonColor.withOpacity(0.7),
                      ),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
