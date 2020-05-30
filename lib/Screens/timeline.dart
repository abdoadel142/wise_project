import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wise/Models/postModel.dart';
import 'package:wise/Models/userData.dart';
import 'package:wise/Screens/newPost.dart';
import 'package:wise/Screens/profile_screen.dart';
import 'package:wise/Screens/search.dart';
import 'package:wise/Screens/settings.dart';
import 'package:wise/classes/DarkThemeProvider.dart';
import 'package:wise/classes/progress.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import 'home_screen.dart';

final usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  final userData currentUser;

  Timeline({this.currentUser});

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<post> posts;
  List<String> followingList = [];

  @override
  void initState() {
    super.initState();

    getTimeline();
    getFollowing();
  }

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .document(widget.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<post> posts =
        snapshot.documents.map((doc) => post.FromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .document(currentUser.id)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingList = snapshot.documents.map((doc) => doc.documentID).toList();
    });
  }

  buildTimeline() {
    if (posts == null) {
      return SliverList(
        delegate: SliverChildListDelegate([circularProgress()]),
      );
    } else if (posts.isEmpty) {
      return SliverList(
        delegate: SliverChildListDelegate([buildUsersToFollow()]),
      );
    } else {
      return SliverList(delegate: new SliverChildListDelegate(posts));
    }
  }

  buildUsersToFollow() {
    return StreamBuilder(
      stream:
          usersRef.orderBy('timestamp', descending: true).limit(30).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> userResults = [];
        snapshot.data.documents.forEach((doc) {
          userData user = userData.FromDocument(doc);
          final bool isAuthUser = currentUser.id == user.id;
          final bool isFollowingUser = followingList.contains(user.id);
          // remove auth user from recommended list
          if (isAuthUser) {
            return;
          } else if (isFollowingUser) {
            return;
          } else {
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
          }
        });
        return Container(
          color: Theme.of(context).accentColor.withOpacity(0.2),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person_add,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Find Users to Follow",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              Column(children: userResults),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('hgfd');
          Navigator.pushNamed(context, newPost.id);
        },
        backgroundColor: themeChange.darkTheme ? Colors.black : Colors.white,
        elevation: 10,
        child: IconButton(
          iconSize: 50,
          icon: themeChange.darkTheme
              ? Image.asset('images/logoDark.png')
              : Image.asset('images/logo.png'),
        ),
      ),

      // backgroundColor: Colors.black12,
      body: RefreshIndicator(
        onRefresh: () => getTimeline(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                "Wise",
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              centerTitle: true,

              actions: <Widget>[
                IconButton(
                  padding: EdgeInsets.all(5),
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Search(),
                      ),
                    );
                  },
                ),
                IconButton(
                  padding: EdgeInsets.all(5),
                  icon: Icon(
                    Icons.settings,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => setting(),
                      ),
                    );
                  },
                ),
              ],
              //     backgroundColor: Colors.black,
              elevation: 0,
              floating: true,
            ),
            buildTimeline()
          ],
        ),
      ),
    );
  }
}
