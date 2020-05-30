import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise/Screens/Login_Screen.dart';
import 'package:wise/Screens/Regester_Screen.dart';
import 'package:wise/Screens/newPost.dart';
import 'package:wise/Screens/testhome.dart';

import 'package:wise/Screens/home_screen.dart';
import 'package:wise/Screens/profile_screen.dart';
import 'package:wise/Wservices/auth_services.dart';
import 'package:wise/classes/DarkThemeProvider.dart';

import 'classes/Styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.devFestPreferences.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        )
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
              title: "Wise",
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
              debugShowCheckedModeBanner: false,
              initialRoute: Login_Screen.id,
              routes: {
                profile.id: (context) => profile(),
                Login_Screen.id: (context) => Login_Screen(),
                Regester_Screen.id: (context) => Regester_Screen(),
                testhome.id: (context) => testhome(),
                home.id: (context) => home(),
                newPost.id: (context) => newPost(),
              });
        },
      ),
    );
  }
}
