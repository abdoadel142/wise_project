import 'dart:async';
import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wise/Models/userData.dart';
import 'package:wise/Screens/activity_feed.dart';
import 'package:wise/Screens/comments.dart';
import 'package:wise/Screens/home_screen.dart';
import 'package:wise/Wservices/auth_services.dart';
import 'package:wise/classes/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class post extends StatefulWidget {
  final String username;
  final String ownerId;
  final String postId;
  final String postContent;
  final String mediaUel;
  final Timestamp dateTime;
  final String topics;
  //final List<String> top;

  final dynamic likes;

  post({
    this.username,
    this.mediaUel,
    this.ownerId,
    this.topics,
    this.postContent,
    this.dateTime,
    this.postId,
    this.likes,
    //this.top
  });

  factory post.FromDocument(DocumentSnapshot doc) {
    return post(
      username: doc['username'],
      ownerId: doc['ownerId'],
      topics: doc['topics'],
      postContent: doc['postcontent'],
      dateTime: doc['timestamp'],
      postId: doc['postId'],
      mediaUel: doc['mediaUrl'],
      likes: doc['likes'],
      //top: List.from(doc['top']),
    );
  }
  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _postState createState() => _postState(
        postId: this.postId,
        postContent: this.postContent,
        ownerId: this.ownerId,
        dateTime: this.dateTime,
        mediaUrl: this.mediaUel,
        username: this.username,
        topics: this.topics,
        likeCount: this.getLikeCount(likes),
        likes: this.likes,
        //top: this.top,
      );
}

class _postState extends State<post> {
  final String ownerId;
  final String postId;
  final String postContent;
  final Timestamp dateTime;
  final String topics;
  final String username;
  final String mediaUrl;
  final List<String> top;
  bool showHeart = false;
  bool isLiked;
  int likeCount;
  Map likes;
  _postState(
      {this.username,
      this.mediaUrl,
      this.postId,
      this.ownerId,
      this.postContent,
      this.dateTime,
      this.topics,
      this.likes,
      this.likeCount,
      this.top});

  addtoTopic() {}

  handleLikePost() {
    bool _isLiked = likes[currentUser.id] == true;
    String idu = currentUser.id;
    print('object');
    if (_isLiked) {
      postsRef
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$idu ': false});
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentUser.id] = false;
      });
    } else if (!_isLiked) {
      postsRef
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$idu': true});
      addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUser.id] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  addLikeToActivityFeed() {
    // add a notification to the postOwner's activity feed only if comment made by OTHER user (to avoid getting notification for our own like)
    bool isNotPostOwner = currentUser.id != ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(postId)
          .setData({
        "type": "like",
        "name": username,
        "userId": ownerId,
        "userProfileImg": currentUser.mediaUrl,
        "postId": postId,
        "mediaUrl": mediaUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeLikeFromActivityFeed() {
    bool isNotPostOwner = currentUser.id != ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  buildPostHeader() {
    return FutureBuilder(
      future: authServices().userColection.document(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        userData user = userData.FromDocument(snapshot.data);
        bool isPostOwner = currentUser.id == ownerId;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: user.mediaUrl == null
                  ? CircleAvatar(
                      backgroundColor: Colors.grey,
                    )
                  : CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(user.mediaUrl),
                    ),
//              CircleAvatar(
//                backgroundImage: CachedNetworkImageProvider(user.mediaUrl),
//              ),

              title: GestureDetector(
                onTap: () => showProfile(context, profileId: user.id),
                child: Text(
                  user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Text(timeago.format(dateTime.toDate())),
              trailing: isPostOwner
                  ? IconButton(
                      onPressed: () => handleDeletePost(context),
                      icon: Icon(Icons.more_vert),
                    )
                  : Text(''),
            ),
            Padding(
              padding: EdgeInsets.all(
                5.0,
              ),
              child: Text(
                postContent,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.start,
                // softWrap: true,
                maxLines: 5,
              ),
            ),
          ],
        );
      },
    );
  }

  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    deletePost();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  // Note: To delete post, ownerId and currentUserId must be equal, so they can be used interchangeably
  deletePost() async {
    // delete post itself
    postsRef
        .document(ownerId)
        .collection('userPosts')
        .document(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // delete uploaded image for thep ost
    if (mediaUrl != '') {
      storageRef.child("post_$postId.jpg").delete();
    } else {
      print('nophoto');
    }

    // then delete all activity feed notifications

    QuerySnapshot activityFeedSnapshot = await activityFeedRef
        .document(ownerId)
        .collection("feedItems")
        .where('postId', isEqualTo: postId)
        .getDocuments();
    activityFeedSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // then delete all comments
    QuerySnapshot commentsSnapshot = await commentsRef
        .document(postId)
        .collection('comments')
        .getDocuments();
    commentsSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  buildPostImage() {
    return mediaUrl == ''
        ? Text('')
        : GestureDetector(
            onDoubleTap: handleLikePost,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.network(
                  mediaUrl,
                  fit: BoxFit.fitWidth,
                ),
                showHeart
                    ? Animator(
                        duration: Duration(milliseconds: 300),
                        tween: Tween(begin: 0.8, end: 1.4),
                        curve: Curves.elasticOut,
                        cycles: 0,
                        builder: (context, animatorState, child) =>
                            Transform.scale(
                              scale: animatorState.value,
                              child: Icon(
                                Icons.favorite,
                                size: 80.0,
                                color: Colors.red,
                              ),
                            ))
                    : Text(""),
              ],
            ),
          );
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0, left: 20.0),
          child: Row(
            children: <Widget>[
              Text(
                'Topic :  ',
                style: TextStyle(color: ThemeData().accentColor),
              ),
              Text(
                '#$topics',
                //style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "$likeCount likes",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: handleLikePost,
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 28.0,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 20.0)),
                GestureDetector(
                  onTap: () => showComments(
                    context,
                    postId: postId,
                    ownerId: ownerId,
                    mediaUrl: mediaUrl,
                  ),
                  child: Icon(
                    Icons.question_answer,
                    size: 28.0,
                    color: Colors.grey,
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 20.0)),
                GestureDetector(
                  onTap: () => print('showing comments'),
                  child: Icon(
                    Icons.bookmark_border,
                    size: 28.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUser.id] == true);

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildPostHeader(),
          mediaUrl == null ? Text('') : buildPostImage(),
          buildPostFooter(),
          Divider(
            thickness: 6.0,
          )
        ],
      ),
    );
  }
}

showComments(BuildContext context,
    {String postId, String ownerId, String mediaUrl, String name}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(
      postId: postId,
      postOwnerId: ownerId,
      postMediaUrl: mediaUrl,
      name: name,
    );
  }));
}
