import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagraam/models/user_model.dart' as model;
import 'package:instagraam/provider/user_provider.dart';
import 'package:instagraam/resources/dark_mode.dart';
import 'package:instagraam/resources/firestore_methods.dart';
import 'package:instagraam/screens/followers_screen.dart';
import 'package:instagraam/screens/login_screen.dart';
import 'package:instagraam/screens/post_list_screen.dart';
import 'package:instagraam/utils/utils.dart';
import 'package:instagraam/widgets/my_appbar.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isLoading = false;
  bool isFollowing = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      userData = userSnap.data()!;
      postLen = postSnap.docs.length;
      following = userSnap.data()!['following'].length;
      followers = userSnap.data()!['followers'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkMode>(context).isDark;
    FirebaseAuth _auth = FirebaseAuth.instance;
    model.User user = Provider.of<UserProvider>(context).getUser;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
              backgroundColor:
                  isDark ? Colors.white :const Color.fromARGB(255, 54, 54, 54),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  MyAppBar(
                    widget: Row(
                      children: [
                        user.uid != widget.uid
                            ? IconButton(
                                onPressed: () {
                                  // Get.back();
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: isDark ? Colors.black : Colors.white,
                                ),
                              )
                            : const Padding(padding: EdgeInsets.all(0)),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          userData['username'],
                          style: TextStyle(
                            color: isDark ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const Spacer(),
                        user.uid != widget.uid
                            ? const Padding(
                                padding: EdgeInsets.all(0),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  _auth.signOut();
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Get.offAll(() => const LoginScreenPage());
                                  showSnackBar("Logout success", context);
                                },
                                icon: Icon(
                                  Icons.logout,
                                  color: isDark ? Colors.black : Colors.white,
                                  size: 26,
                                ),
                              ),
                      ],
                    ),
                    height: 55,
                    margin: const EdgeInsets.all(10),
                    shapeDecoration: ShapeDecoration(
                      // gradient: LinearGradient(colors: [
                      //   Colors.pink.shade100,
                      //   Colors.pink.shade200,
                      //   Colors.pink.shade300,
                      // ]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(user.uid != widget.uid
                            ? userData['photoUrl']
                            : user.photoUrl),
                      ),
                      SizedBox(
                        width: width * 0.07,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              buildProfileFields(postLen, 'posts'),
                              SizedBox(
                                width: width * 0.05,
                              ),
                              buildProfileFields(following, 'following'),
                              SizedBox(
                                width: width * 0.05,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(
                                        () => FollowersScreen(uid: widget.uid));
                                  },
                                  child: buildProfileFields(
                                      followers, 'followers')),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.017,
                          ),
                          user.uid == widget.uid
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    fixedSize: Size(
                                      width * 0.57,
                                      height * 0.05,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  onPressed: () {
                                    //
                                  },
                                  child: const Text('Edit profile'),
                                )
                              : SizedBox(
                                  width: width * 0.6,
                                  height: height * 0.052,
                                  child: Row(
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          fixedSize: isFollowing
                                              ? Size(width * 0.3, height * 0.3)
                                              : Size(
                                                  width * 0.55, height * 0.3),
                                          backgroundColor: !isFollowing
                                              ? Colors.blue
                                              : const Color.fromARGB(
                                                  255, 205, 205, 205),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: isFollowing
                                            ? () async {
                                                await FirestoreMethods()
                                                    .followUser(user.uid,
                                                        userData['uid']);
                                                setState(() {
                                                  isFollowing = false;
                                                  followers--;
                                                });
                                              }
                                            : () async {
                                                await FirestoreMethods()
                                                    .followUser(user.uid,
                                                        userData['uid']);
                                                setState(() {
                                                  isFollowing = true;
                                                  followers++;
                                                });
                                              },
                                        child: Text(
                                          isFollowing ? "Unfollow" : "follow",
                                          style: TextStyle(
                                            color: isFollowing
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      !isFollowing
                                          ? const SizedBox(
                                              width: 0,
                                            )
                                          : OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                fixedSize: Size(
                                                    width * 0.25, height * 0.3),
                                                backgroundColor:
                                                    Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () {},
                                              child: const Text(
                                                "suggest",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return GridView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snap.data!.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snaps = snap.data!.docs[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(PostListScreen(snap: snap.data));
                                  },
                                  child: Image.network(
                                    snaps['postUrl'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            });
                      }),
                ],
              ),
            ),
          );
  }

  Widget buildProfileFields(int count, String fieldText) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            color: Provider.of<DarkMode>(context).isDark
                ? Colors.black
                : Colors.white,
          ),
        ),
        Text(
          fieldText,
          style: TextStyle(
            color: Provider.of<DarkMode>(context).isDark
                ? Colors.black
                : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
