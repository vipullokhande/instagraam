import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagraam/models/user_model.dart' as model;
import 'package:instagraam/provider/user_provider.dart';
import 'package:instagraam/resources/dark_mode.dart';
import 'package:instagraam/resources/firestore_methods.dart';
import 'package:instagraam/widgets/post_card.dart';
import 'package:provider/provider.dart';

class PostListScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const PostListScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkMode>(context).isDark;
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark ? Colors.white :const Color.fromARGB(255, 52, 52, 52),
        leading: Padding(
          padding: const EdgeInsets.only(left: 30, top: 7),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.black : Colors.white,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            top: 5,
          ),
          child: Text(
            widget.snap.docs.length.toString(),
            style: TextStyle(
              color: isDark ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Provider.of<DarkMode>(context).isDark
          ? Colors.white
          :const Color.fromARGB(255, 52, 52, 52),
      body: ListView.builder(
          padding: const EdgeInsets.only(top: 7),
          scrollDirection: Axis.vertical,
          itemCount: widget.snap.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot snaps = widget.snap.docs[index];
            return GestureDetector(
              onDoubleTap: () async {
                await FirestoreMethods().likePost(
                    widget.snap['postID'], user.uid, widget.snap['likes']);
              },
              child: PostCard(snaps: snaps),
            );
            // Card(
            //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(16),
            //   ),
            //   clipBehavior: Clip.antiAlias,
            //   child: Image.network(
            //     snaps['postUrl'],
            //     height: 250,
            //     fit: BoxFit.cover,
            //   ),
            // );
          }),
    );
  }
}
