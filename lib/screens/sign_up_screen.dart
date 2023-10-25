import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagraam/resources/auth_methods.dart';
import 'package:instagraam/responsive/mobile_screen_layout.dart';
import 'package:instagraam/responsive/responsive_layout.dart';
import 'package:instagraam/responsive/web_screen_layout.dart';
import 'package:instagraam/screens/login_screen.dart';
import 'package:instagraam/utils/utils.dart';
import 'package:instagraam/widgets/dialog_button.dart';
import 'package:instagraam/widgets/text_input_field.dart';

class SignUpScreenPage extends StatefulWidget {
  const SignUpScreenPage({Key? key}) : super(key: key);

  @override
  State<SignUpScreenPage> createState() => _SignUpScreenPageState();
}

class _SignUpScreenPageState extends State<SignUpScreenPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  // ignore: unused_field
  bool _isLoading = false;
  String userName = '';
  void selectImage(ImageSource source) async {
    Uint8List im = await pickImage(source);
    setState(() {
      _image = im;
    });
  }

  void signupuser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    if (res != 'success') {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(res, context);
    } else if (res == 'success') {
      userName = _usernameController.text;
      setState(() {
        _isLoading = false;
      });
      Get.off(
        () => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
      );
      showSnackBar("Welcome $userName", context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              "https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?b=1&k=20&m=476085198&s=170667a&w=0&h=Ct4e1kIOdCOrEgvsQg4A1qeuQv944pPFORUQcaGw4oI="),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 88,
                    child: IconButton(
                      onPressed: () {
                        showSource();
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextInputField(
                textEditingController: _usernameController,
                hintText: "Enter your username",
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              TextInputField(
                textEditingController: _emailController,
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),
              TextInputField(
                textEditingController: _passwordController,
                hintText: "Enter your Password",
                textInputType: TextInputType.visiblePassword,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextInputField(
                textEditingController: _bioController,
                hintText: "Enter your bio",
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signupuser,
                child: Container(
                  height: 57,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          7,
                        ),
                      ),
                    ),
                    color: Color.fromARGB(255, 35, 135, 220),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          backgroundColor: Colors.pink,
                        )
                      : const Text(
                          "Create",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Already have an account?"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const LoginScreenPage()));
                      _usernameController.text = '';
                      _emailController.text = '';
                      _passwordController.text = '';
                      _bioController.text = '';
                      // setState(() {
                      //   _isLoading = false;
                      // });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
