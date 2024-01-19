import 'package:cloud_firestore/cloud_firestore.dart';

class PostClass{
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImage;
  final likes;

  const PostClass({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.likes,
    required this.profileImage
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'postId': postId,
    'description': description,
    'datePublished': datePublished,
    'likes': likes,
    'postUrl': postUrl,
    'profileImage': profileImage
  };

  static PostClass fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostClass(
      description: snapshot['description'], 
      uid: snapshot['uid'], 
      postId: snapshot['postId'], 
      postUrl: snapshot['posturl'], 
      datePublished: snapshot['datePublished'], 
      likes: snapshot['likes'], 
      username: snapshot['username'],
      profileImage: snapshot['profileImage']
    );
  }
}