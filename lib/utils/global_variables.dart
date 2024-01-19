import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/screens/home_screens/add_post_screen.dart';
import 'package:instagramclone/screens/home_screens/feed_screen.dart';
import 'package:instagramclone/screens/home_screens/profile_screen.dart';
import 'package:instagramclone/screens/home_screens/search_screen.dart';

const webscreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('likes'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid ,)
];
