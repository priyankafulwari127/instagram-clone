 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:instagramclone/resources/storage_methods.dart';
import 'package:instagramclone/resources/user.dart';

class AuthMethod{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<UserClass> getUserDetails() async{
    User currentUser = auth.currentUser!;

    DocumentSnapshot snap = await firebaseFirestore.collection('users').doc(currentUser.uid).get();

    return UserClass.fromSnap(snap);
  }

  //sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async{
    String res = 'Some error ocureed';
    try{
      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && bio.isNotEmpty){
        //register user
        UserCredential cred = await auth.createUserWithEmailAndPassword(email: email, password: password);

        print(cred.user!.uid);

        String photoURL = await StorageMethods().uploadImageToStorage('profilePictures', file, false);

        UserClass userClass = UserClass(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoURL: photoURL,
          following: [],
          followers: [],
        );

        //add user to our database //in this uids are same
        await firebaseFirestore.collection('users').doc(cred.user!.uid).set(userClass.toJson());

        // if we use this method then firebase generate random id that
        // that is the UIDs are not same
        // await firebaseFirestore.collection('users').add({
        //   'username': username,
        //   'uid': cred.user!.uid,
        //   'email': email,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });

        res = 'success';
      }
    } catch (err){
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password, 
  }) async{
    String res = 'Some error occured';

    try{
      if(email.isNotEmpty && password.isNotEmpty){
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      }else{
        res = 'please enter all fields';
      }
    }catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async{
    auth.signOut();
  }
}