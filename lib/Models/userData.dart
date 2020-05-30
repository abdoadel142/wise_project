import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class userData {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String id;
  final String bio;
  final String mediaUrl;

  userData(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.gender,
      this.bio,
      this.mediaUrl});
  factory userData.FromDocument(DocumentSnapshot doc) {
    return userData(
      id: doc['id'],
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      phone: doc['phone'] ?? '',
      gender: doc['gender'] ?? '',
      bio: doc['bio'] ?? '',
      mediaUrl: doc['mediaUrl'],
    );
  }
}
