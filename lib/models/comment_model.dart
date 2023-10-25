import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String username;
  final String uid;
  final String postID;
  final String photoUrl;
  final String text;
  // ignore: prefer_typing_uninitialized_variables
  final datePublished;
  final String commentID;
  Comment({
    required this.username,
    required this.uid,
    required this.postID,
    required this.photoUrl,
    required this.text,
    required this.commentID,
    this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'postID': postID,
        'photoUrl': photoUrl,
        'text': text,
        'commentID': commentID,
        'datePublished': datePublished,
      };

  static Comment fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data()! as Map<String, dynamic>;
    return Comment(
        username: snap['username'],
        uid: snap['uid'],
        postID: snap['postID'],
        photoUrl: snap['photoUrl'],
        text: snap['text'],
        commentID: snap['commentID']);
  }
}
