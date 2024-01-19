import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagramclone/resources/post.dart';
import 'package:instagramclone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStroreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = 'Some error occured';
    try {
      String photoURL =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      PostClass postClass = PostClass(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          likes: [],
          datePublished: DateTime.now(),
          postUrl: photoURL,
          profileImage: profileImage);

      _firestore.collection('posts').doc(postId).set(
            postClass.toJson(),
          );

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is emmpty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //deleting post

  Future<void> deletePost(String postId) async {
    try {
      _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection('users').doc(followId).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      }else{
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection('users').doc(followId).update({
          'following': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
