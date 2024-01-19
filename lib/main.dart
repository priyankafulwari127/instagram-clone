import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/colors/colors.dart';
import 'package:instagramclone/resources/user_provider.dart';
import 'package:instagramclone/responsive/mobileScreen_layout.dart';
import 'package:instagramclone/responsive/responsive_layout.dart';
import 'package:instagramclone/responsive/webScreen_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramclone/screens/auth_screens.dart/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  // FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //   if (user == null) {
  //     print('User is currently signed out!');
  //   } else {
  //     print('User is signed in!');
  //   }
  // });

  WidgetsFlutterBinding.ensureInitialized();
  // if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyB4N-jIv07D_vh2oJdVTk463P1W1Zc5baE',
            appId: '1:175545222244:web:76cdb42284660d75538b71',
            messagingSenderId: '175545222244',
            projectId: 'instagramclone-e2775',
            storageBucket: 'instagramclone-e2775.appspot.com'));
  // } else {
  //   await Firebase.initializeApp();
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
