import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagraam/provider/post_provider.dart';
import 'package:instagraam/provider/user_provider.dart';
import 'package:instagraam/resources/dark_mode.dart';
import 'package:instagraam/responsive/mobile_screen_layout.dart';
import 'package:instagraam/responsive/responsive_layout.dart';
import 'package:instagraam/responsive/web_screen_layout.dart';
import 'package:instagraam/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

//firebase_storage,firebase_database,cloud_firestore,provider,intl,firebase_auth,uuid
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PostProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DarkMode(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Instagram VIP Clone',
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const LoginScreenPage();
          },
        ),
      ),
    );
  }
}
