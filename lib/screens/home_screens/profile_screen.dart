import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/colors/colors.dart';
import 'package:instagramclone/resources/auth_method.dart';
import 'package:instagramclone/resources/firestore_methods.dart';
import 'package:instagramclone/screens/auth_screens.dart/image_picker.dart';
import 'package:instagramclone/screens/auth_screens.dart/login_screen.dart';
import 'package:instagramclone/screens/home_screens/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followersLen = 0;
  int followingLen = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      followersLen = userSnap.data()!['followers'].length;
      followingLen = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      userData = userSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 35,
                                backgroundImage: NetworkImage(
                                    // 'https://images.unsplash.com/photo-1530349311076-ab305120ccfc?q=80&w=989&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                    userData['photoURL'] ?? ''),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        builStatColumn(postLen, 'posts'),
                                        builStatColumn(
                                            followersLen, 'followers'),
                                        builStatColumn(
                                            followingLen, 'following'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FirebaseAuth.instance.currentUser!
                                                    .uid ==
                                                widget.uid
                                            ? FollowButton(
                                                backgroundColor:
                                                    mobileBackgroundColor,
                                                borderColor: Colors.grey,
                                                text: 'Sign Out',
                                                textColor: primaryColor,
                                                function: () async {
                                                  await AuthMethod().signOut();
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginScreen(),
                                                    ),
                                                  );
                                                },
                                              )
                                            : isFollowing
                                                ? FollowButton(
                                                    backgroundColor:
                                                        Colors.white,
                                                    borderColor: Colors.grey,
                                                    text: 'Unfollow',
                                                    textColor: Colors.grey,
                                                    function: () async {
                                                      await FireStroreMethods()
                                                          .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid'] ?? '',
                                                      );
                                                      setState(() {
                                                        isFollowing = false;
                                                        followersLen--;
                                                      });
                                                    },
                                                  )
                                                : FollowButton(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    borderColor: Colors.blue,
                                                    text: 'Follow',
                                                    textColor: Colors.white,
                                                    function: () async {
                                                      await FireStroreMethods()
                                                          .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid'] ?? '',
                                                      );
                                                      setState(() {
                                                        isFollowing = true;
                                                        followersLen++;
                                                      });
                                                    },
                                                  )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              userData['username'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 1),
                            child: Text(
                              userData['bio'] ?? '',
                            ),
                          ),
                          const Divider(),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('posts')
                                .where('uid', isEqualTo: widget.uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    (snapshot.data! as dynamic).docs.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  DocumentSnapshot snap =
                                      (snapshot.data! as dynamic).docs[index];
                                  return Container(
                                    child: Image(
                                      image: NetworkImage(
                                        (snap.data()! as dynamic)['postUrl'],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }

  Column builStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
