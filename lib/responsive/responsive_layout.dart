import 'package:flutter/material.dart';
import 'package:instagraam/provider/post_provider.dart';
import 'package:instagraam/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      {Key? key,
      required this.webScreenLayout,
      required this.mobileScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    PostProvider _postProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
    await _postProvider.refreshPosts();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        if (constraints.maxWidth > 600) {
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      }),
    );
  }
}
