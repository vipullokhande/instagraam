import 'package:flutter/cupertino.dart';
import 'package:instagraam/models/post_model.dart';
import 'package:instagraam/resources/firestore_methods.dart';

class PostProvider with ChangeNotifier {
  Post? _post;
  Post get getPost => _post!;
  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  Future<void> refreshPosts() async {
    Post post = await _firestoreMethods.getPostDetails();
    _post = post;
    notifyListeners();
  }
}
