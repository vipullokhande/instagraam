import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagraam/models/user_model.dart' as model;
import 'package:instagraam/provider/user_provider.dart';
import 'package:instagraam/resources/dark_mode.dart';
import 'package:instagraam/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkMode>(context).isDark;

    // ignore: unused_local_variable
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      height: 70,
      padding: const EdgeInsets.only(top: 6, left: 5),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color.fromARGB(214, 245, 244, 244),
                      const Color.fromARGB(213, 244, 242, 242),
                      const Color.fromARGB(213, 236, 234, 234),
                    ]
                  : [
                      const Color.fromARGB(213, 100, 100, 100),
                      const Color.fromARGB(213, 85, 88, 90),
                      const Color.fromARGB(212, 72, 72, 72),
                    ])),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundImage: NetworkImage(widget.snap['photoUrl']),
              ),
              const SizedBox(
                width: 6,
              ),
              TextButton(
                child: Text(
                  widget.snap['username'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ?const Color.fromARGB(255, 0, 0, 0)
                        :const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Get.to(() => ProfileScreen(
                        uid: widget.snap['uid'],
                      ));
                },
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '  ${widget.snap['text']}',
                  style: TextStyle(
                    wordSpacing: 1,
                    fontWeight: FontWeight.w300,
                    color: isDark
                        ?const Color.fromARGB(255, 56, 55, 55)
                        : Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
