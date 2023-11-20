// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagraam/models/user_model.dart' as model;
import 'package:instagraam/provider/user_provider.dart';
import 'package:instagraam/resources/dark_mode.dart';
import 'package:instagraam/screens/feed_screen.dart';
import 'package:instagraam/screens/profile_screen.dart';
import 'package:instagraam/screens/search_screen.dart';
import 'package:instagraam/utils/utils.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkMode>(context).isDark;

    FirebaseAuth _auth = FirebaseAuth.instance;
    model.User user = Provider.of<UserProvider>(context).getUser;
    List<Widget> list = [
      const FeedScreen(),
      const SearchScreen(),
      ProfileScreen(
        uid: user.uid,
      )
    ];
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.active) {
            if (snap.hasData) {
              return Scaffold(
                body: IndexedStack(
                  index: index,
                  children: list,
                ),
              );
            } else if (snap.hasError) {
              showSnackBar(snap.error.toString(), context);
              return Center(
                child: IconButton(
                  onPressed: offResonsive(),
                  icon: const Icon(Icons.replay_circle_filled_outlined),
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) {
          setState(() {
            index = idx;
          });
        },
        selectedItemColor: isDark ? Colors.black : Colors.cyanAccent,
        unselectedItemColor:
            isDark ?const Color.fromARGB(255, 104, 103, 103) : Colors.white,
        backgroundColor:
            isDark ?const Color.fromARGB(255, 255, 255, 255) : Colors.black,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
