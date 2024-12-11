import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:HikedHimalayas/pages/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();

    // Initialize Lottie animation controller
    _lottieController = AnimationController(vsync: this);

    // Navigate after Lottie animation ends with fallback in case of any issues
    Future.delayed(const Duration(seconds: 3), () {
      _navigateToHome();
    });
  }

  // Method to navigate to HomeScreen with zoom-in effect
  void _navigateToHome() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (_, __, ___) => const Home(),
      transitionsBuilder: (_, animation, __, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ));
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/Animation.json',
          controller: _lottieController,
          onLoaded: (composition) {
            _lottieController.duration = composition.duration;
            _lottieController.forward().then((_) {
              _navigateToHome(); // Navigate after animation finishes
            });
          },
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
