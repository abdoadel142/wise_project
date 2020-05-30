import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wise/Models/userData.dart';
import 'package:wise/Screens/EditProfile.dart';
import 'package:wise/Screens/home_screen.dart';
import 'package:wise/Wservices/auth_services.dart';
import 'package:wise/classes/constant.dart';
import 'package:wise/classes/progress.dart';
import 'package:wise/Models/postModel.dart';

class profile extends StatefulWidget {
  static const id = 'profile';
  final String profileId;

  profile({this.profileId});

  @override
  _profileState createState() => _profileState(profileId: this.profileId);
}

String randomImage = 'https://picsum.photos/200/300';

class _profileState extends State<profile> {
  final String profileId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  _profileState({this.profileId});
  bool profileimage = false;
  bool isFollowing = false;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<post> posts = [];

  @override
  void initState() {
    super.initState();
    getProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
    print('ddddddddddddd');

    print(profileId);
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .document(currentUser.id)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .getDocuments();
    setState(() {
      followerCount = snapshot.documents.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .document(widget.profileId)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingCount = snapshot.documents.length;
    });
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .document(profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    setState(() {
      postCount = snapshot.documents.length;
      posts = snapshot.documents.map((doc) => post.FromDocument(doc)).toList();
      isLoading = false;
    });
  }

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfile(currentUserId: currentUser.id)));
  }

  Container buildButton({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 250.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // color: isFollowing ? Colors.grey[700] : Colors.black,
            border: Border.all(
                //    color: isFollowing ? Colors.grey[700] : Colors.white,
                ),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    // viewing your own profile - should show edit profile button
    bool isProfileOwner = currentUser.id == profileId;
    if (isProfileOwner) {
      return buildButton(
        text: "Edit Profile",
        function: editProfile,
      );
    } else if (isFollowing) {
      return buildButton(
        text: "Unfollow",
        function: handleUnfollowUser,
      );
    } else if (!isFollowing) {
      return buildButton(
        text: "Follow",
        function: handleFollowUser,
      );
    }
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });
    // remove follower
    followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .document(currentUser.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // remove following
    followingRef
        .document(currentUser.id)
        .collection('userFollowing')
        .document(profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete activity feed item for them
    activityFeedRef
        .document(profileId)
        .collection('feedItems')
        .document(currentUser.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });
    // Make auth user follower of THAT user (update THEIR followers collection)
    followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .document(currentUser.id)
        .setData({});
    // Put THAT user on YOUR following collection (update your following collection)
    followingRef
        .document(currentUser.id)
        .collection('userFollowing')
        .document(widget.profileId)
        .setData({});
    // add activity feed item for that user to notify about new follower (us)
    activityFeedRef
        .document(widget.profileId)
        .collection('feedItems')
        .document(currentUser.id)
        .setData({
      "type": "follow",
      "ownerId": widget.profileId,
      "name": currentUser.name,
      "userId": currentUser.id,
      "userProfileImg": currentUser.mediaUrl,
      "timestamp": timestamp,
    });
  }

  buildProfileHeader() {
    return FutureBuilder(
      future: authServices().userColection.document(profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('');
        }

        userData user = userData.FromDocument(snapshot.data);

        return Padding(
          padding: EdgeInsets.only(
            top: 16.0,
          ),
          child: Column(
            children: <Widget>[
              user.mediaUrl == null
                  ? CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey,
                    )
                  : CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(user.mediaUrl),
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              buildCountColumn("posts", postCount),
                              buildCountColumn("followers", followerCount),
                              buildCountColumn("following", followingCount),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildProfileButton(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  user.bio,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildProfilePosts() {
    if (isLoading) {
      return Center(
        child: circularProgress(),
      );
    } else if (posts.isEmpty) {
      return Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              "there is No Posts yet",
              style: TextStyle(
                //       color: Colors.grey,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: posts,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isProfileOwner = currentUser.id == profileId;

    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Profile'),
        leading: isProfileOwner
            ? Icon(Icons.person)
            : IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(),
          Divider(
            thickness: 5,
          ),
          buildProfilePosts(),
        ],
      ),
    );
  }
}

//
//
//Column(
//children: <Widget>[
//Row(
//children: <Widget>[

//Container(
//alignment: Alignment.centerLeft,
//padding: EdgeInsets.only(top: 12.0),
//child:
//),
//),
//],
//),
//Padding(
//padding: EdgeInsets.all(20),
//child: Row(
//children: <Widget>[
//Expanded(
//flex: 1,
//child: Column(
//children: <Widget>[
//Row(
//mainAxisSize: MainAxisSize.max,
//mainAxisAlignment:
//MainAxisAlignment.spaceEvenly,
//children: <Widget>[
//buildCountColumn("posts", 0),
//buildCountColumn("followers", 0),
//buildCountColumn("following", 0),
//],
//),

//],
//),
//),
//],
//),
//),
//Container(
//alignment: Alignment.centerLeft,
//padding: EdgeInsets.only(top: 2.0),
//child: Text(
//// user.bio
//'',
//),
//),
//],
//),
