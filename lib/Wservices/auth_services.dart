import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wise/Models/user.dart';
import 'package:wise/Models/userData.dart';
import 'package:wise/Screens/home_screen.dart';

class authServices {
  final CollectionReference topicsColection =
      Firestore.instance.collection('topics');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userColection =
      Firestore.instance.collection('user');
  final DateTime timestamp = DateTime.now();
  userData curentuser;
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(id: user.uid) : null;
  }

  //adduser
  Future addUserData(String uid, String name, String email, String phone,
      String gender) async {
    await userColection.document(uid).setData({
      'id': uid,
      'name': name,
      'emali': email,
      'phone': phone,
      'gender': gender,
      'date': timestamp,
      'bio': '',
    });
  }

//regester
  Future<String> createAuthUser(String email, String password, String name,
      String phone, String gender) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      curentuser = await addUserData(user.uid, name, user.email, phone, gender);
    } catch (e) {
      print(e.toString());
      return null;
    }
    return 'done';
  }

  Future<userData> Currentuser() async {
    FirebaseUser user = await _auth.currentUser();
    DocumentSnapshot doc = await userColection.document(user.uid).get();
    return userData.FromDocument(doc);
  }

//sign out
  createtopics() {}

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
