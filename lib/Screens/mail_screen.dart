import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wise/Screens/chat.dart';
import 'home_screen.dart';

class Mail extends StatefulWidget {
  @override
  _MailState createState() => _MailState();
}

class _MailState extends State<Mail> {
  var topicsIcons = [
    FaIcon(FontAwesomeIcons.footballBall),
    FaIcon(FontAwesomeIcons.chalkboardTeacher),
    FaIcon(FontAwesomeIcons.city),
    Icon(Icons.fastfood),
    FaIcon(FontAwesomeIcons.brain),
    FaIcon(FontAwesomeIcons.plane),
    FaIcon(FontAwesomeIcons.autoprefixer),
    FaIcon(FontAwesomeIcons.clock),
    FaIcon(FontAwesomeIcons.music),
    FaIcon(FontAwesomeIcons.film),
    FaIcon(FontAwesomeIcons.bookReader),
    FaIcon(FontAwesomeIcons.ship),
    FaIcon(FontAwesomeIcons.play),
    FaIcon(FontAwesomeIcons.baby),
    FaIcon(FontAwesomeIcons.cat),
    FaIcon(FontAwesomeIcons.laugh),
    Icon(Icons.pregnant_woman),
    FaIcon(FontAwesomeIcons.graduationCap),
    FaIcon(FontAwesomeIcons.home),
  ];

  var data = [
    'Sports',
    'Eduction',
    'Culture',
    'Food',
    'Science',
    'Travel',
    'Work issues',
    'free time',
    'Music',
    'Movies',
    'Books',
    'Travel',
    'Hobbies',
    'Childern',
    'Pets',
    'Humor',
    'Sexual assault',
    'College Life',
    'Family Problems'
  ];
  var colors = [
    Colors.green,
    Colors.blue,
    Colors.blueGrey,
    Colors.orange,
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.teal,
    Colors.purple,
    Colors.limeAccent,
    Colors.brown,
    Colors.grey,
    Colors.deepOrangeAccent,
    Colors.deepPurpleAccent,
    Colors.cyan,
    Colors.amber,
    Colors.pinkAccent,
    Colors.green,
    Colors.indigo,
    Colors.redAccent,
  ];
  @override
  Widget build(BuildContext context) {
    //  var orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: Icon(
                  Icons.apps,
                  //      color: Colors.white,
                ),
                title: Text(
                  'Topics',
                ),
                //      backgroundColor: Colors.black,
                floating: false,
                pinned: true,
              ),
            ];
          },
          body: Stack(
            children: <Widget>[
              CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Center(
                        child: Text(
                          'Spaces',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                              fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.2,
                        ),
                        delegate: SliverChildBuilderDelegate(_buildCategoryItem,
                            childCount: data.length)),
                  )
                ],
              )
            ],
          )),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => chat(
              topicname: data[index],
            ),
          ),
        );
      },
      elevation: 10.0,

      highlightElevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0)),
      ),
      //disabledColor: Colors.red,
      //disabledTextColor: Colors.black87,
      color: colors[index],

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          topicsIcons[index],
          SizedBox(height: 5.0),
          Text(
            data[index],
            textAlign: TextAlign.center,
            maxLines: 3,
            style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold,
              //    color: Colors.white
            ),
          ),
        ],
      ),
    );
  }
}
