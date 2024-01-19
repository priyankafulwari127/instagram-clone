import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramclone/colors/colors.dart';
import 'package:instagramclone/screens/home_screens/post_card.dart';
import 'package:instagramclone/utils/global_variables.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: width > webscreenSize
          ? null
          : AppBar(
              backgroundColor: width > webscreenSize ? webBackgroundColor : mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'Assets/Images/insta.svg',
                color: Colors.white,
                height: 36,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.messenger_outline,
                  ),
                )
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(
              margin: EdgeInsets.symmetric(
                horizontal: width > webscreenSize ? width * 0.3 : 0,
                vertical: width > webscreenSize ? 15 : 0,
              ),
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}
