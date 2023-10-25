import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagraam/models/user_model.dart' as model;
import 'package:instagraam/provider/user_provider.dart';
import 'package:instagraam/resources/dark_mode.dart';
import 'package:instagraam/resources/firestore_methods.dart';
import 'package:instagraam/widgets/comment_card.dart';
import 'package:instagraam/widgets/text_input_field.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkMode>(context).isDark;

    model.User user = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark
            ?const Color.fromARGB(255, 255, 255, 255)
            :const Color.fromARGB(168, 34, 33, 33),
        resizeToAvoidBottomInset: false,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postID'])
              .collection('comments')
              .orderBy('datePublished', descending: false)
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
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return CommentCard(
                  snap: snapshot.data!.docs[index].data(),
                );
              },
            );
          },
        ),
        bottomNavigationBar: Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding:const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 27,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextInputField(
                  textEditingController: _commentController,
                  hintText: 'Comment as ${user.username}',
                  textInputType: TextInputType.text,
                ),
              ),
              Card(
                color: Colors.white,
                child: IconButton(
                  onPressed: _commentController.text.isNotEmpty
                      ? () {
                          FirestoreMethods().postComment(
                              user.username,
                              user.uid,
                              widget.snap['postID'],
                              user.photoUrl,
                              _commentController.text);
                          setState(() {
                            _commentController.text = '';
                          });
                        }
                      : null,
                  icon: Icon(
                    Icons.send,
                    color: _commentController.text.isNotEmpty
                        ? Colors.black
                        : Colors.grey.shade400,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
