import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise/Models/userData.dart';
import 'package:wise/Screens/home_screen.dart';
import 'package:wise/Screens/testhome.dart';
import 'package:wise/Wservices/auth_services.dart';
import 'package:wise/classes/DarkThemeProvider.dart';
import 'Regester_Screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login_Screen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<Login_Screen> {
  String _email;
  String _password;
  String sign_error = 'invalid user name or password';
  bool s_error = false;
  bool spinner = false;
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        // color: Colors.white,
        child: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Hero(
                      tag: 'logo',
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.0),
                        child: Container(
                          height: 150,
                          child: themeChange.darkTheme
                              ? Image.asset('images/logoDark.png')
                              : Image.asset('images/logo.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (val) =>
                      val.isEmpty ? 'email cant be empty' : null,
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (val) =>
                      val.isEmpty ? 'password cant be empty' : null,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  obscureText: true,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  s_error == true ? sign_error : '',
                  style: TextStyle(color: Colors.red, fontSize: 15.0),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Forget Password ?',
                  style: TextStyle(fontSize: 15.0),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: RawMaterialButton(
                    onPressed: () async {
                      setState(() {
                        spinner = true;
                      });

                      Future user = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _email, password: _password)
                          .then((user) async {
                        FirebaseUser useru =
                            await FirebaseAuth.instance.currentUser();
                        userData userdata = await authServices().Currentuser();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => home(),
                          ),
                        );
                      }).catchError((e) {
                        setState(() {
                          s_error = true;
                        });
                        print(e.toString());
                      });
                      setState(() {
                        spinner = false;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ),
                    elevation: 6.0,
                    fillColor:
                        themeChange.darkTheme ? Colors.white30 : Colors.black,
                    shape: StadiumBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Dont have an account? ',
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    new GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Regester_Screen.id);
                      },
                      child: new Text(
                        "Sign up",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
