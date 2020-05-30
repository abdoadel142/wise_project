import 'package:flutter/material.dart';
import 'package:wise/Screens/home_screen.dart';
import 'package:wise/Wservices/auth_services.dart';

class Regester_Screen extends StatefulWidget {
  static const id = 'Regester_screen';

  @override
  _regesterState createState() => _regesterState();
}

class _regesterState extends State<Regester_Screen> {
  String _email;
  String _password;
  String _gender = 'Male';
  String _phone;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  authServices _auth = authServices();
  String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.0),
                      child: Container(
                        height: 50,
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                //email
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
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //password
                TextFormField(
                  validator: (val) => val.length < 6
                      ? 'password must be at least 6 chars '
                      : null,
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
                    labelStyle: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //name
                TextFormField(
                  validator: (val) => val.isEmpty ? 'name cant be empty' : null,
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your Name',
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //phone
                TextFormField(
                  validator: (val) =>
                      val.length < 11 ? 'phone must be 11 numbers ' : null,
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Enter your Phone',
                    labelText: 'Phone',
                    labelStyle: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Gender ',
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                    Radio(
                      value: 'Male',
                      activeColor: Colors.black,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    Text(
                      'Male  ',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    Radio(
                        activeColor: Colors.black,
                        value: 'Female',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        }),
                    Text(
                      'Female  ',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: RawMaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result = await _auth.createAuthUser(
                            _email, _password, _name, _phone, _gender);

                        if (result == null) {
                          setState(() {
                            error = 'email is already taken';
                          });
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => home(),
                            ),
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ),
                    elevation: 6.0,
                    fillColor: Colors.black,
                    shape: StadiumBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: new Text(
                      "I already have an account",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
