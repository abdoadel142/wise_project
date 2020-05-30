import 'package:flutter/material.dart';
import 'package:wise/Models/postModel.dart';
import 'package:wise/classes/progress.dart';
import 'home_screen.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;

  PostScreen({this.userId, this.postId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef
          .document(userId)
          .collection('userPosts')
          .document(postId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        print('hamooooooooooooot');
        print(postId);
        print(userId);

        //print(snapshot.data['type']);
        post Post = post.FromDocument(snapshot.data);

        return Center(
          child: Scaffold(
            appBar: AppBar(),
            body: ListView(
              children: <Widget>[
//                Container(
//                  child: post.FromDocument(snapshot.data),
//                )
                Post
              ],
            ),
          ),
        );
      },
    );
  }
}

//class PostScreen extends StatelessWidget {
//  final String userId;
//  final String postId;
////  post _post;
//  PostScreen({this.userId, this.postId});
//
//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder(
//      future: postsRef
//          .document(userId)
//          .collection('userPosts')
//          .document(postId)
//          .get(),
//      builder: (context, snapshot) {
//        if (!snapshot.hasData) {
//          return circularProgress();
//        }
//        print(userId);
//        print('3awez anaaaaaaaaam');
//        print(postId);
//        post _post = post.FromDocument(snapshot.data);
//
//        return Center(
//          child: Scaffold(
//            appBar: AppBar(
//              title: Text("Post"),
//            ),
//            body: ListView(
//              children: <Widget>[
//                Container(
//                  child: _post,
//                )
//              ],
//            ),
//          ),
//        );
//      },
//    );
//  }
//}
