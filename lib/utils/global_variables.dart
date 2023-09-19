import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tentacles/screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/search_screen.dart';
import '../screens/profile_screen.dart';

const webScreenSize = 600;

final homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('notify'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
