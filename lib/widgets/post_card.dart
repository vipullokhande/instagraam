// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagraam/models/user_model.dart' as model;
import 'package:instagraam/provider/user_provider.dart';
import 'package:instagraam/resources/dark_mode.dart';
import 'package:instagraam/resources/firestore_methods.dart';
import 'package:instagraam/screens/comment_screen.dart';
import 'package:instagraam/screens/profile_screen.dart';
import 'package:instagraam/utils/utils.dart';
import 'package:instagraam/widgets/post_options.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snaps;

  const PostCard({Key? key, required this.snaps}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snaps['postID'])
          .collection('comments')
          .get();
      commentLen = snapshot.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkMode>(context).isDark;
    model.User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: const EdgeInsets.only(top: 6),
      clipBehavior: Clip.antiAlias,
      height: 420,
      decoration: ShapeDecoration(
        color: isDark
            ? const Color.fromARGB(192, 241, 241, 242)
            : const Color.fromARGB(168, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(widget.snaps['profUrl']),
              ),
              const Spacer(
                flex: 1,
              ),
              TextButton(
                child: Text(
                  widget.snaps['username'],
                  style: TextStyle(
                    color: isDark
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Get.to(() => ProfileScreen(
                        uid: widget.snaps['uid'],
                      ));
                },
              ),
              const Spacer(
                flex: 7,
              ),
              IconButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              clipBehavior: Clip.antiAlias,
                              alignment: Alignment.center,
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  FirestoreMethods()
                                      .deletePost(widget.snaps['postID']);
                                },
                                title: const Text("Delete"),
                              ),
                            ));
                  },
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: isDark
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(255, 255, 255, 255),
                  ))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onDoubleTap: () async {
                await FirestoreMethods().likePost(
                    widget.snaps['postID'], user.uid, widget.snaps['likes']);
              },
              child: Image(
                height: 230,
                width: double.maxFinite,
                fit: BoxFit.fill,
                image: NetworkImage(
                  widget.snaps['postUrl'],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
            child: Row(
              children: [
                const SizedBox(
                  width: 3,
                ),
                GestureDetector(
                    onTap: () async {
                      await FirestoreMethods().likePost(widget.snaps['postID'],
                          user.uid, widget.snaps['likes']);
                    },
                    child: PostOptions(
                      icon: widget.snaps['likes'].contains(user.uid)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 36,
                      color: widget.snaps['likes'].contains(user.uid)
                          ? Colors.red
                          : isDark
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : const Color.fromARGB(255, 255, 255, 255),
                    )),
                const SizedBox(
                  width: 3,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => CommentScreen(
                          snap: widget.snaps,
                        ));
                  },
                  child: PostOptions(
                    icon: Icons.comment_bank_outlined,
                    size: 36,
                    color: isDark
                        ?const Color.fromARGB(255, 0, 0, 0)
                        :const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                GestureDetector(
                  child: PostOptions(
                    icon: Icons.share,
                    size: 36,
                    color: isDark
                        ?const Color.fromARGB(255, 0, 0, 0)
                        :const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                const Flexible(child: Center()),
                GestureDetector(
                  child: PostOptions(
                    icon: Icons.save_alt_rounded,
                    size: 38,
                    color: isDark
                        ?const Color.fromARGB(255, 0, 0, 0)
                        :const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 15,
              ),
              Text(
                "${widget.snaps['likes'].length} likes",
                style: TextStyle(
                    color: isDark
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                width: 15,
              ),
              // Text(
              //   "${snaps['description']}",
              //   maxLines: 1,
              //   overflow: TextOverflow.fade,
              //   style: const TextStyle(
              //       color: Colors.black, fontWeight: FontWeight.w400),
              // ),
              const Spacer(),
              Text(
                DateFormat.yMMMd().format(
                  widget.snaps['datePublished'].toDate(),
                ),
                style: TextStyle(
                    color: isDark
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w400,
                    fontSize: 10),
              ),
              Text(
                " ${DateFormat.Hms().format(
                  widget.snaps['datePublished'].toDate(),
                )}",
                style: TextStyle(
                    color: isDark
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w400,
                    fontSize: 10),
              ),
              const SizedBox(
                width: 7,
              )
            ],
          ),
          TextButton(
            onPressed: () {
              Get.to(() => CommentScreen(
                    snap: widget.snaps,
                  ));
            },
            child: Text(
              "view all $commentLen comments",
              style: TextStyle(
                color: isDark
                    ?const Color.fromARGB(255, 0, 0, 0)
                    :const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
