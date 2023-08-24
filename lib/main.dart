import 'package:flutter/material.dart';
import 'package:shop_app/Models/Custome_rout.dart';
import 'package:shop_app/Screens/Cart_Screen.dart';
import 'package:shop_app/Screens/Edite_Products_Screen.dart';
import 'package:shop_app/Screens/Log_In_Screen.dart';
import 'package:shop_app/Screens/Orders_Screen.dart';
import 'package:shop_app/Screens/Product_Details_Screen.dart';
import 'package:shop_app/Screens/Products_Overview_Screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/SignUp_Screen.dart';
import 'package:shop_app/Screens/Splash_Screen.dart';
import 'package:shop_app/Screens/User_Products_Screen.dart';
import 'package:shop_app/Screens/User_Profile.dart';
import 'package:shop_app/providers/Cart_Details.dart';
import 'package:shop_app/providers/Comments_Provider.dart';
import 'package:shop_app/providers/Order_Provider.dart';
import 'package:shop_app/providers/Profile_Provider.dart';
import 'package:shop_app/providers/Reviews_Providers.dart';
import 'package:shop_app/providers/ThemeProvider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shop_app/teanslations/codegen_loader.g.dart';
import 'core/color.dart';
import 'providers/Products_provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      path: 'assets/translation/',
      supportedLocales: const[
        Locale('en'),
        Locale('ar')

      ],
      assetLoader: const CodegenLoader(),
      fallbackLocale:const Locale('en'),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
   bool darktheme = true ;

  @override
  Widget build(BuildContext context) {
    // SharedPreferences.getInstance().then((value) {
    //   darktheme = value.getBool("darktheme")!;
    // });

    return MultiProvider(
        providers: [

          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),

          ChangeNotifierProvider(
            create: (ctx) => MyTheme()..intitialize(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, authdata, Productsprevious) => Products(
                authdata.token,
                authdata.userid,
                Productsprevious == null ? [] : Productsprevious.items),
            create: (ctx) => Products("", "", []),
          ),

          ChangeNotifierProxyProvider<Auth, Cart>(
            update: (ctx, authdata, Productsprevious) => Cart(authdata.userid),
            create: (ctx) => Cart("",),
          ),
          ChangeNotifierProxyProvider<Auth, Reviews>(
              create: (ctx) => Reviews( "", "" ,[]),
              update: (ctx, authdata, prevReviews) => Reviews(
                  authdata.token,
                  authdata.userid,
                  prevReviews == null ? [] : prevReviews.reviews)
          ),
          ChangeNotifierProxyProvider<Auth, Comments>(
              create: (ctx) => Comments( "", "" ,[]),
              update: (ctx, authdata, prevReviews) => Comments(
                  authdata.token,
                  authdata.userid,
                  prevReviews == null ? [] : prevReviews.comments)
          ),
          ChangeNotifierProxyProvider<Auth, Profile>(
              create: (ctx) => Profile(userid: "" , authtoken: ""),
              // update: (ctx, authdata, pre) => pre!..Updat(authdata.userid,authdata.token),
              update: (ctx, authdata, _) => Profile(userid:authdata.userid , authtoken: authdata.token)
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            update: (ctx, authdata, previousorder) => Order(
                authdata.token,
                authdata.userid,
                previousorder == null ? [] : previousorder.orders),
            create: (ctx) => Order("", "", []),
          ),
        ],
        child: Consumer2<Auth,MyTheme>(
          builder: (ctx, authdata, theme , _) => MaterialApp(
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            title: 'RE-Sellers',
            theme: ThemeData(
              scaffoldBackgroundColor: theme.isdark? Color(0xFF2C2E36) :  Color(
                  0xFFB1D6F1),
              dividerColor: theme.isdark?  blackTextField : whiteTextField,
              bottomSheetTheme: BottomSheetThemeData(backgroundColor: theme.isdark? Color(0xFF2C2E36) :  Color(
                  0xFFB1D6F1),),
              buttonColor: theme.isdark? greenButton : blueButton,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  primary: theme.isdark? greenButton : blueButton,
                )
              ),
              listTileTheme: ListTileTheme.of(context).copyWith(
                tileColor: theme.isdark?  blackTextField : whiteTextField,
              ),
              bottomNavigationBarTheme: BottomNavigationBarTheme.of(context).copyWith(
                backgroundColor: theme.isdark?  Colors.grey : Colors.lightBlue,
              ),
              drawerTheme: DrawerTheme.of(context).copyWith(
                backgroundColor: theme.isdark? Color(0xFF414450) :  Color(
                    0xFF92ACC9),
              ),
              primarySwatch:theme.isdark? Colors.grey : Colors.lightBlue,
              accentColor:theme.isdark? Colors.lightGreenAccent : Colors.blue.shade500,
              fontFamily: "'Lato",
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android : CustomePageTranstionBuilder(),
                  TargetPlatform.iOS : CustomePageTranstionBuilder(),
                }
              )
            ),
            home: authdata.IsAuth
                ? ProductsOverViewScreen()
                : FutureBuilder(
                    future: authdata.TryAutoLogin(),
                    builder: (ctx, snpashot) =>
                        snpashot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : LoginPage(),
                  ),

            routes: {
              ProductDetailScreen.routename: (ctx) => ProductDetailScreen(),
              ProductsOverViewScreen.routeName: (ctx) => ProductsOverViewScreen(),
              CartScreen.routname: (ctx) => CartScreen(),
              OrdersScreen.routname: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditeProductsScreen.routename: (ctx) => EditeProductsScreen(),
              ProfileScreen.routeName: (ctx)=> ProfileScreen(),
              LoginPage.routeName : (ctx)=> LoginPage(),
              SignUpPage.routeName : (ctx)=> SignUpPage(),
            },
          ),
        ));
  }
}
