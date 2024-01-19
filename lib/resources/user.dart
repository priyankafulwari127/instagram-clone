import 'package:cloud_firestore/cloud_firestore.dart';

class UserClass{
  final String email;
  final String uid;
  final String photoURL;
  final String bio;
  final String username;
  final List followers;
  final List following;

  const UserClass({
    required this.email,
    required this.uid,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    required this.photoURL
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'photoURL': photoURL,
    'email': email,
    'bio': bio,
    'follower': followers,
    'following': following
  };

  static UserClass fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserClass(
        email: snapshot['email'] ?? '',
        bio: snapshot['bio'] ?? '',
        followers: snapshot['followers'] ?? [],
        following: snapshot['following'] ?? [],
        photoURL: snapshot['photoURL'] ?? '',
        uid: snapshot['uid'] ?? '',
        username: snapshot['username'] ?? ''
    );
  }
}