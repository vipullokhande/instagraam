import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String decscription;
  final String uid;
  // ignore: prefer_typing_uninitialized_variables
  final datePublished;
  // ignore: prefer_typing_uninitialized_variables
  final likes;
  final String username;
  final String profUrl;
  final String postID;
  final String postUrl;
  //
  Post({
    required this.decscription,
    required this.uid,
    required this.datePublished,
    required this.likes,
    required this.username,
    required this.profUrl,
    required this.postID,
    required this.postUrl,
  });
  //
  Map<String, dynamic> toJson() => {
        'decscription': decscription,
        'uid': uid,
        'datePublished': datePublished,
        'likes': likes,
        'username': username,
        'profUrl': profUrl,
        'postID': postID,
        'postUrl': postUrl,
      };
  //
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data()! as Map<String, dynamic>;
    return Post(
      decscription: snapshot['decscription'],
      uid: snapshot['uid'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
      username: snapshot['username'],
      profUrl: snapshot['profUrl'],
      postID: snapshot['postID'],
      postUrl: snapshot['postUrl'],
    );
  }
  //
}
