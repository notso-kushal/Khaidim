import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:neww/controllers/authController.dart';
import 'package:neww/controllers/data_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      enabledDebugging: false,
      publicKey: "test_public_key_d5d9f63743584dc38753056b0cc737d5",
      builder: (context, navKey) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyAppWithSplash(),
          navigatorKey: navKey,
          localizationsDelegates: [KhaltiLocalizations.delegate],
        );
      },
    );
  }
}

class MyAppWithSplash extends StatefulWidget {
  @override
  _MyAppWithSplashState createState() => _MyAppWithSplashState();
}

class _MyAppWithSplashState extends State<MyAppWithSplash> {
  @override
  void initState() {
    super.initState();
    AuthController().onReady();
    DataController().onReady();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      centered: true,
      duration: 5000,
      splashTransition: SplashTransition.decoratedBoxTransition,
      nextScreen: AuthController().handleAuthState(),
      splash: Lottie.asset(
        'images/splash.json',
        height: 800,
        width: 800,
      ),
    );
  }
}
