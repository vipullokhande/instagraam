import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagraam/models/user_model.dart' as model;
import 'package:instagraam/provider/user_provider.dart';
import 'package:instagraam/resources/dark_mode.dart';
import 'package:instagraam/resources/firestore_methods.dart';
import 'package:instagraam/utils/utils.dart';
import 'package:instagraam/widgets/dialog_button.dart';
import 'package:instagraam/widgets/my_appbar.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _decriptionController = TextEditingController();
  Uint8List? _file;
  bool isShowPost = false;
  bool isLoading = false;
  void selectImage(ImageSource source) async {
    Uint8List file = await pickImage(source);
    setState(() {
      _file = file;
      isShowPost = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _decriptionController.dispose();
  }

  postImage(
    String uid,
    String username,
    String photoUrl,
  ) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          username, photoUrl, uid, _decriptionController.text, _file!);
      if (res == "success") {
        setState(() {
          isLoading = false;
        });

        showSnackBar("Posted", context);
        offAllResponsive();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  void clearImage() {
    if (_file == null && isShowPost == false) {
      Get.back();
    }
    setState(() {
      _file = null;
      isShowPost = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<DarkMode>(context).isDark;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    model.User user = Provider.of<UserProvider>(context).getUser;

    void showSource() => showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            elevation: 0,
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: const Color.fromARGB(224, 107, 223, 250),
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  child: const Text(
                    "Select option",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DialogButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          selectImage(ImageSource.camera);
                        },
                        icon: Icons.camera_alt_rounded,
                        text: 'Camera',
                      ),
                      DialogButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          selectImage(ImageSource.gallery);
                        },
                        icon: Icons.photo,
                        text: 'Gallery',
                      ),
                    ],
                  ),
                ),
                Container(
                  color: const Color.fromARGB(159, 211, 211, 211),
                  width: double.infinity,
                  height: 70,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                    ),
                  ),
                ),
              ],
            ),
          );
        });

    return Scaffold(
      backgroundColor: isDark ? Colors.white : const Color.fromARGB(255, 44, 44, 44),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _file != null && isShowPost
                  ? Padding(
                      padding: EdgeInsets.only(top: height * 0.1),
                      child: Column(
                        children: [
                          isLoading
                              ? const LinearProgressIndicator()
                              : const Padding(
                                  padding: EdgeInsets.only(top: 0),
                                ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 34,
                                backgroundImage: NetworkImage(user.photoUrl),
                              ),
                              SizedBox(
                                width: width * 0.7,
                                child: TextField(
                                  controller: _decriptionController,
                                  maxLines: 6,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 226, 190, 190),
                                    hintText: "Description",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          Divider.createBorderSide(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                height: height * 0.5,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.fill,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: IconButton(
                                  onPressed: clearImage,
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 600,
                      width: 350,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color.fromARGB(143, 163, 211, 251)
                            : const Color.fromARGB(255, 147, 147, 147),
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Text(
                            "Tap   '   +   '  button\n\nto Upload photo",
                            style: TextStyle(
                              color: isDark ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          IconButton(
                            splashColor:
                                const Color.fromARGB(255, 111, 58, 255),
                            onPressed: () {
                              showSource();
                            },
                            icon: Icon(
                              Icons.add,
                              size: 35,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            MyAppBar(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7)
                  .copyWith(left: 4),
              height: height * 0.07,
              shapeDecoration: ShapeDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ?const [
                            Color.fromARGB(131, 248, 187, 140),
                            Color.fromARGB(139, 244, 143, 160),
                            Color.fromARGB(141, 244, 143, 180),
                          ]
                        :const [
                            Color.fromARGB(187, 248, 187, 140),
                            Color.fromARGB(207, 244, 143, 160),
                            Color.fromARGB(192, 244, 143, 180),
                          ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              widget: Row(
                children: [
                  IconButton(
                    onPressed: clearImage,
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: isDark ? Colors.black : Colors.white,
                      size: 24,
                    ),
                  ),
                  Text(
                    'Post to',
                    style: TextStyle(
                      color: isDark ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const Spacer(
                    flex: 6,
                  ),
                  //Post Button
                  isShowPost
                      ? OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent,
                            fixedSize: const Size(90, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            postImage(
                              user.uid,
                              user.username,
                              user.photoUrl,
                            );
                          },
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.0,
                            ),
                          ),
                        )
                      : const Center(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
