import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/colors/colors.dart';
import 'package:instagramclone/resources/firestore_methods.dart';
import 'package:instagramclone/resources/user.dart';
import 'package:instagramclone/resources/user_provider.dart';
import 'package:instagramclone/screens/home_screens/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserClass userClass = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              return CommentCard(
                snap: (snapshot.data! as dynamic).docs[index].data()
              );
            },
            itemCount: (snapshot.data! as dynamic).docs.length,
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  userClass.photoURL,
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${userClass.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FireStroreMethods().postComment(
                    widget.snap['postId'],
                    commentController.text,
                    userClass.uid,
                    userClass.username,
                    userClass.photoURL,
                  );
                  setState(() {
                    commentController.text = '';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: blueColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
