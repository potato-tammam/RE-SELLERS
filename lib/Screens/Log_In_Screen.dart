
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/SignUp_Screen.dart';
import 'package:shop_app/teanslations/locale_Keys.g.dart';
import '../Models/http_Exception.dart';
import 'package:shop_app/providers/auth.dart';
import '../Widgets/Custom_TextField.dart';
import '../Widgets/Main_Button.dart';
import '../core/color.dart';
import '../core/text_style.dart';
import 'package:easy_localization/easy_localization.dart';


class LoginPage extends StatefulWidget {
  static const routeName = '/LogIn';
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {


  TextEditingController userEmail = TextEditingController();
  TextEditingController userPass = TextEditingController();

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
  Future<void> _submit( String email  , String password) async {

    setState(() {
      _isLoading =true ;
    });
    try {

      //Sign user up
     await Provider.of<Auth>(context,listen: false).LogIn(email, password);




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
       const errormessage = "Could not authenticate you. please try again";
      //const
       print (error.toString());
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
                LocaleKeys.wlecom.tr(),
                style: headline1,
              ),
              SizedBox(height: 10.0),
              Text(
                LocaleKeys.pls.tr(),
                style: headline3,
              ),
              SizedBox(height: 60.0),
              textFild(
                controller: userEmail,
                keyBordType: TextInputType.emailAddress,
                icon: Icon(Icons.email_outlined ,
                    color: grayText.withOpacity(0.3)),
                hintTxt: LocaleKeys.email.tr(),
                ctx: context,
              ),
              textFild(
                controller: userPass,
                ctx: context,
                icon: Icon(Icons.password,
                  color: grayText.withOpacity(0.3),),
                isObs: true,
                hintTxt: LocaleKeys.password.tr(),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: TextButton(
                    onPressed: ()async {
                      await context.setLocale(Locale('ar'));
                    },
                    child: Text(
                      'Forgot Password?',
                      style: headline3,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    _isLoading? CircularProgressIndicator() :  Mainbutton(
                      onTap: () {
                          print( userEmail.text.toString() + userPass.text.toString());
                        _submit(
                          userEmail.text.toString(), userPass.text.toString(),
                        );
                        //    print(userEmail.text + userPass.text);

                      },
                      text: LocaleKeys.signin.tr(),
                      btnColor: Theme.of(context).buttonColor,
                    ),
                    SizedBox(height: 20.0),
                    // Mainbutton(
                    //   onTap: () {},
                    //   text: 'Sign in with google',
                    //   image: 'google.png',
                    //   btnColor: white,
                    //   txtColor: blackBG,
                    // ),
                    SizedBox(height: 20.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignUpPage.routeName);
                      },
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: LocaleKeys.noacc.tr(),
                            style: headline.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: LocaleKeys.signup.tr(),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
