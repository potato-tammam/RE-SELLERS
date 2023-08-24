
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Models/Custome_rout.dart';
import 'package:shop_app/Screens/Cart_Screen.dart';
import 'package:shop_app/Screens/SearchScreen.dart';
import 'package:shop_app/Screens/Settings%20Screen.dart';
import 'package:shop_app/Widgets/App_Drawer.dart';
import 'package:shop_app/Widgets/Custom_TapBar.dart';
import 'package:shop_app/Widgets/ImageSlider.dart';
import 'package:shop_app/Widgets/badg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Cart_Details.dart';
import 'package:shop_app/providers/Products_provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../Widgets/ProductsGrid.dart';
import '../teanslations/locale_Keys.g.dart';





enum Filtervalues {
  Favorits ,
  All ,
}
class ProductsOverViewScreen extends StatefulWidget {
static const routeName = "/poverview";
  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  int _selectedIndex = 0;
 void reset (){
   setState(() {
     _favpritsOnly = false ;
     _selectedIndex = 0 ;

   });
 }
  bool _isloading = false;
  bool _favpritsOnly = false ;
  bool _isinit = true ;

  @override
  void didChangeDependencies() async {

  if(_isinit){
    setState(() {
      _isloading =true;
    });

  await Provider.of<Products>(context).FetchProducts().then((_)async{
      await Provider.of<Products>(context ,listen: false).GetLAstFourProducts().then((_) {

        setState(() {
          _isloading =false;
          _selectedIndex = 0 ;
      });
      });
    });
  }

  _isinit =false;
    super.didChangeDependencies();
  }
  void _navigation(int index ){
  if(index ==2 ){
    Navigator.of(context).push(CustomRoute(widgetBuilder: (ctx)=>SearchScreen() )).then((value) => {
      reset()
    });
  }
    if(index==3){
      Navigator.of(context).pushReplacement(CustomRoute(widgetBuilder: (ctx)=>SettingsScreen() )).then((value) => {
        reset()
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Re-Sellers'),
        centerTitle: true,
        actions: [
          Consumer<Cart>(
            builder: (_ ,cartdata , ch )=> Badge(
                child: ch as Widget ,
                value: cartdata.ItemCount.toString() ,
              ),

            child: IconButton(
              onPressed: (){
                Navigator.of(context).pushNamed(
                 CartScreen.routname,
                );
               },
                icon: Icon(Icons.shopping_cart),
            ),
          ),

        ],

      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0 ,vertical: 10),
          child: GNav(

            selectedIndex: _selectedIndex,
            backgroundColor: Theme.of(context).primaryColor,
            gap: 6,
            color: Colors.white,
            activeColor: Theme.of(context).accentColor,
            tabBackgroundColor: Colors.white30,
            padding: EdgeInsets.all(15),
            onTabChange: (index){

                if(index == 0 ){
                  setState(() {
                    _favpritsOnly = false ;
                    _selectedIndex = index;
                  });

                  print(_selectedIndex);
                }
                if(index == 1 ){
                  setState(() {
                    _favpritsOnly = true ;
                    _selectedIndex = index;
                  });

                  print(_selectedIndex);

                }
               if(index == 2 ){
                 setState(() {
                   _selectedIndex = index;
                 });

                 // _favpritsOnly = false ;
                  _navigation(index);

                  print(_selectedIndex);

               }
                if(index == 3 ){
                  setState(() {
                    _selectedIndex = index;
                  });

                  // _favpritsOnly = false ;
                  _navigation(index);

                  print(_selectedIndex);

                }
            },
            tabs: [
              GButton(
                icon: Icons.home,
                text: LocaleKeys.home.tr(),
              ),
              GButton(
                icon: _selectedIndex == 1 ? Icons.favorite : Icons.favorite_border,
                text: LocaleKeys.favs.tr(),
              ),
              GButton(
                icon: Icons.search,
                text: LocaleKeys.search.tr(),
              ),
              GButton(
                icon: Icons.settings,
                text: LocaleKeys.sittings.tr(),
              ),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
       body:_isloading ? Center(
         child:TweenAnimationBuilder<double>(
           tween: Tween<double>(begin: 0.0, end: 1),
           duration: const Duration(milliseconds: 2500),
           builder: (context, value, _) => CircularProgressIndicator(
             color: Theme.of(context).accentColor,
              strokeWidth: 6,
               value: value),
         )
      )
           :
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              _favpritsOnly? SizedBox(height: 1,): Container(
                margin: EdgeInsets.only(right: 15),
                color: Theme.of(context).accentColor.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5 ,vertical: 3),
                  child: Row(

                      children : [
                        Text(LocaleKeys.newproductstitle.tr() ,textAlign: TextAlign.left, style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),]
                  ),
                ),
              ),
             _favpritsOnly? SizedBox(height: 1,): ImageSlider(),
              SizedBox(height: 20,),


              Container(
                margin: EdgeInsets.only(right: 15),
                color: Theme.of(context).accentColor.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5 ,vertical: 3),
                  child: Row(
                    children : [
                      Text(_favpritsOnly?LocaleKeys.urfavs.tr() : LocaleKeys.avalibenow.tr() ,textAlign: TextAlign.left, style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),]
                  ),
                ),
              ),
             _favpritsOnly? SizedBox(height: 1,): TapBar(),
              Container( height: 500, child: ProductsGrid(_favpritsOnly)),
            ],
          ),
        ),
      ),
    );
  }
}


