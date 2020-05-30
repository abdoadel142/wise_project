import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wise/Models/userData.dart';
import 'package:flutter/material.dart';
import 'package:wise/Screens/activity_feed.dart';
import 'package:wise/Screens/mail_screen.dart';
import 'package:wise/Screens/search.dart';
import 'package:wise/Screens/profile_screen.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:wise/Screens/timeline.dart';
import 'package:wise/Wservices/auth_services.dart';
import 'package:wise/classes/DarkThemeProvider.dart';
import 'package:wise/classes/progress.dart';
import 'package:flutter_icons/flutter_icons.dart';

final StorageReference storageRef = FirebaseStorage.instance.ref();
final chatref = Firestore.instance.collection('spaces');

final postsRef = Firestore.instance.collection('posts');
final commentsRef = Firestore.instance.collection('comments');
final activityFeedRef = Firestore.instance.collection('feed');
final followersRef = Firestore.instance.collection('followers');
final followingRef = Firestore.instance.collection('following');
final CollectionReference usersRef = Firestore.instance.collection('user');
final timelineRef = Firestore.instance.collection('timeline');
final DateTime timestamp = DateTime.now();
userData currentUser;

class home extends StatefulWidget {
  static const id = 'home_screen';

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin {
  PageController pageController;
  userData cuser;
  int pageIndex = 0;
  bool found = false;
  @override
  void initState() {
    pageController = PageController();

    super.initState();
    setState(() {
      getcurrentuser();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

//  List<Widget> list = [
//    feed(),
//    ActivityFeed(),
//    Search(),
//    mail(),
//    profile(profileId: userid),
//  ];
  int _page = 0;

  int _selectedItemPosition = 0;
  getcurrentuser() async {
    currentUser = await authServices().Currentuser();
    setState(() {
      found = true;
    });
    print('welcome');
    print(currentUser.id);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return found
        ? Scaffold(
            bottomNavigationBar: SnakeNavigationBar(
              style: SnakeBarStyle.floating,
              snakeShape: SnakeShape.circle,
              snakeColor: themeChange.darkTheme ? Colors.white : Colors.black,
              backgroundColor:
                  themeChange.darkTheme ? Colors.black : Colors.white,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              padding: EdgeInsets.all(1),
              currentIndex: pageIndex,
              onPositionChanged: onTap,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FlutterIcons.notifications_active_mdi),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FlutterIcons.group_faw),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.userAlt),
                ),
              ],
            ),
            body: PageView(
              children: <Widget>[
                //feed(),
                Timeline(
                  currentUser: currentUser,
                ),

                ActivityFeed(),

                Mail(),
                profile(profileId: currentUser.id),
              ],
              controller: pageController,
              onPageChanged: onPageChanged,
              physics: NeverScrollableScrollPhysics(),
            ),
            //list[_selectedItemPosition],
          )
        : Scaffold(
            body: circularProgress(),
          );
  }
}
