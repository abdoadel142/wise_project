import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wise/Wservices/auth_services.dart';
import 'package:wise/classes/DarkThemeProvider.dart';

import 'Login_Screen.dart';

class setting extends StatefulWidget {
  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text("Dark Mode"),
              leading: Icon(FontAwesomeIcons.moon),
              trailing: Switch(
                value: themeChange.darkTheme,
                onChanged: (bool value) {
                  themeChange.darkTheme = value;
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
                title: Text("About"),
                leading: Icon(FontAwesomeIcons.addressBook),
                trailing: Icon(Icons.arrow_drop_down)),
          ),
          Card(
            child: ListTile(
                title: Text("help"),
                leading: Icon(FontAwesomeIcons.questionCircle),
                trailing: Icon(Icons.arrow_drop_down)),
          ),
          Card(
            child: ListTile(
                title: Text("Contact Us"),
                leading: Icon(FontAwesomeIcons.phoneSquare),
                trailing: Icon(Icons.arrow_drop_down)),
          ),
          Card(
            child: ListTile(
                title: Text("Send Feedback"),
                leading: Icon(Icons.message),
                trailing: Icon(Icons.arrow_drop_down)),
          ),
          Card(
            child: GestureDetector(
              onTap: logout,
              child: ListTile(
                title: Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
                leading: Icon(FontAwesomeIcons.signOutAlt),
              ),
            ),
          ),
        ],
      ),
    );
  }

  logout() async {
    await authServices().signOut();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, Login_Screen.id);
  }
}
