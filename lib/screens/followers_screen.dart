import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagraam/screens/profile_screen.dart';

class FollowersScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final uid;
  const FollowersScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: widget.uid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(snapshot.data!.docs[index]
                        .data()['followers']
                        .toString()),
                    onTap: () {
                      Get.to(ProfileScreen(
                          uid: snapshot.data!.docs[index]
                              .data()['followers']
                              .toString()));
                    },
                  ),
                );
              });
        },
      ),
    );
  }
}
