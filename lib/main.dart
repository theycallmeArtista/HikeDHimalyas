import 'dart:async';

import 'package:HikedHimalayas/pages/Liked.dart';
import 'package:HikedHimalayas/pages/Profile.dart';
import 'package:HikedHimalayas/pages/home_screen.dart';
import 'package:HikedHimalayas/widgets/More_activity.dart';
import 'package:HikedHimalayas/widgets/SettingsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import to manage system UI settings
import 'package:lottie/lottie.dart';

// Import provider to manage theme state
import 'package:provider/provider.dart';

// Import your page files for routes here

import 'package:HikedHimalayas/auth/login_screen.dart';

import 'home_screen.dart';

// ThemeNotifier to manage the theme
class ThemeNotifier with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the app to immersive full-screen mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/splash', // Start with the splash screen
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/home': (context) => const Home(),
              '/favorites': (context) => const Liked(),
              '/profile': (context) => ProfileScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/activities': (context) => const MoreActivityScreen(),
              '/login': (context) => LoginPage(), // Route for the login screen
            },
            theme: themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          );
        },
      ),
    );
  }
}

// SplashScreen widget with Lottie animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate to BottomNav screen after the animation completes
        Navigator.pushReplacementNamed(
          context,
          '/home', // Navigate to the home screen after the splash
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/Animation - 1730610747712.json', // Replace with the actual path to your Lottie file
          controller: _animationController,
          onLoaded: (composition) {
            _animationController.duration = composition.duration;
            _animationController.forward(); // Start the animation
          },
        ),
      ),
    );
  }
}
