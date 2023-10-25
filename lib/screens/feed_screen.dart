import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instagraam/models/user_model.dart' as model;
import 'package:instagraam/provider/user_provider.dart';
import 'package:instagraam/resources/dark_mode.dart';
import 'package:instagraam/screens/add_post_screen.dart';
import 'package:instagraam/screens/profile_screen.dart';
import 'package:instagraam/widgets/my_appbar.dart';
import 'package:instagraam/widgets/post_card.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const FeedScreen({Key? key, this.snap}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkMode>(context).isDark;
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: isDark ? Colors.white :const Color.fromARGB(214, 0, 0, 0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Colors.white : Colors.cyanAccent,
        title: MyAppBar(
            margin: const EdgeInsets.only(
              top: 3,
            ),
            padding: const EdgeInsets.only(top: 3),
            shapeDecoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            widget: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  fit: BoxFit.cover,
                  height: 34,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (isDark) {
                      Provider.of<DarkMode>(context, listen: false).makeLight();
                    } else {
                      Provider.of<DarkMode>(context, listen: false).makeDark();
                    }
                  },
                  icon: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                IconButton(
                    onPressed: () {
                      Get.to(() => const AddPostScreen());
                    },
                    icon: const Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.black,
                      size: 27,
                    )),
                const SizedBox(
                  width: 7,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(ProfileScreen(
                      uid: user.uid,
                    ));
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                    radius: 22,
                  ),
                ),
              ],
            ),
            height: 55),
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
              padding: const EdgeInsets.only(top: 14, bottom: 14),
              itemCount: snapshot.data!.docs.length - 1,
              itemBuilder: (context, index) {
                return PostCard(
                  snaps: snapshot.data!.docs[index].data(),
                );
              });
        },
      ),
    );
  }
}
