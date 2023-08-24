import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Widgets/App_Drawer.dart';
import 'package:shop_app/providers/ThemeProvider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/color.dart';
import '../teanslations/locale_Keys.g.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String initnal = "Choose a language";

  bool lockAppSwitchVal = true;

  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.lightBlueAccent);
    // bool? isdark  = Provider.of<MyTheme>(context , listen: false).isdark ;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.sittings.tr(),
        ),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.common.tr(),
                    style: headingStyle,
                  ),
                ],
              ),
              const Divider(),
              ListTile(
                tileColor: Theme.of(context).scaffoldBackgroundColor,
                leading: Icon(Icons.cloud),
                title: Text(
                  LocaleKeys.environment.tr(), style: TextStyle(
                    color: whiteText
                ),
                ),
                subtitle: Text("Flutter - Laravel" , style: TextStyle(
                  color: whiteText
                ),),
              ),
              const Divider(),
              Consumer<Auth>(
                builder: (ctx, auth, _) => ListTile(
                  tileColor: Theme.of(context).scaffoldBackgroundColor,
                  leading: const Icon(Icons.exit_to_app),
                  title: Text(
                    LocaleKeys.signout.tr(), style: TextStyle(
                      color: whiteText
                  ),
                  ),
                  onTap: () {
                    auth.Logout();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(LocaleKeys.personalization.tr(), style: headingStyle),
                ],
              ),
              ListTile(
                tileColor: Theme.of(context).scaffoldBackgroundColor,
                leading: const Icon(Icons.language_rounded),
                title: Text(
                  LocaleKeys.language.tr(), style: TextStyle(
                    color: whiteText
                ),
                ),
                trailing: DropdownButton(
                  elevation: 10,
                  iconSize: 25,
                  items: [
                    DropdownMenuItem(
                      child: Text("English"),
                      value: "en",
                    ),
                    DropdownMenuItem(
                      child: Text("Arabic"),
                      value: "ar",
                    ),
                  ],
                  onChanged: (value) async {
                    setState(() {
                      initnal = value.toString();
                    });
                    if (value == "en") {
                      await context.setLocale(Locale("en"));
                    } else if (value == "ar") {
                      await context.setLocale(Locale("ar"));
                    }
                  },
                ),
              ),
              const Divider(),
              ListTile(
                tileColor: Theme.of(context).scaffoldBackgroundColor,
                leading: const Icon(Icons.dark_mode),
                title: Text(
                  LocaleKeys.theme.tr(), style: TextStyle(
                    color: whiteText
                ),
                ),
                trailing: Consumer<MyTheme>(
                  builder: (context, theme, _) => Switch(
                      value: theme.isdark,
                      activeColor: Theme.of(context).accentColor,
                      onChanged: (val) {
                        theme.SetTheme(val);
                      }),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(LocaleKeys.misc.tr(), style: headingStyle),
                ],
              ),
              ListTile(
                tileColor: Theme.of(context).scaffoldBackgroundColor,
                leading: Icon(Icons.file_open_outlined),
                title: Text(
                  LocaleKeys.terms.tr(), style: TextStyle(
                    color: whiteText
                ),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('RE-SELLERS'),
                            content: Text(
                                "All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner,"
                                    " whether by formal meetings of a fixed duration, or any other means, for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services/products,"
                                    " in accordance with and subject to, prevailing law of (Address). Any use of the above terminology or other words in the singular, plural,"
                                    " capitalisation and/or he/she or they, are taken as interchangeable and therefore as referring to same"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text('OK'))
                            ],
                          ));
                },
              ),
              const Divider(),
              ListTile(
                tileColor: Theme.of(context).scaffoldBackgroundColor,
                leading: Icon(Icons.file_copy_outlined),
                title: Text(
                  LocaleKeys.source.tr(), style: TextStyle(
                    color: whiteText
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
