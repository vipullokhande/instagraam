import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagraam/models/comment_model.dart';
import 'package:instagraam/models/post_model.dart';
import 'package:instagraam/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  Future<String> uploadPost(
    String usernmae,
    String profUrl,
    String uid,
    String description,
    Uint8List file,
  ) async {
    String res = 'Some error occured';
    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postID = const Uuid().v1();
      Post post = Post(
        decscription: description,
        uid: uid,
        datePublished: DateTime.now(),
        likes: [],
        username: usernmae,
        profUrl: profUrl,
        postID: postID,
        postUrl: postUrl,
      );
      await _firestore.collection('posts').doc(postID).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

//
  Future<Post> getPostDetails() async {
    DocumentSnapshot snapshot =
        (await _firestore.collection('posts').get()) as DocumentSnapshot<Post?>;
    return Post.fromSnap(snapshot);
  }

//
  Future<void> likePost(String postID, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  //
  Future<void> postComment(
    String username,
    String uid,
    String postID,
    String photoUrl,
    String text,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentID = const Uuid().v1();
        Comment comment = Comment(
            username: username,
            uid: uid,
            postID: postID,
            photoUrl: photoUrl,
            text: text,
            commentID: commentID);
        await _firestore
            .collection('posts')
            .doc(postID)
            .collection('comments')
            .doc(commentID)
            .set(comment.toJson());
      } else {
        // ignore: avoid_print
        print('Text is empty');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  //
  Future<void> deletePost(String postID) async {
    try {
      await _firestore.collection('posts').doc(postID).delete();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  //

  Future<void> followUser(String uid, String followID) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      List following = (snapshot.data()! as dynamic)['following'];
      if (following.contains(followID)) {
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followID])
        });
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followID])
        });
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
