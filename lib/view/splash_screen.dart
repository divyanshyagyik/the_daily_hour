import 'dart:async';
import 'package:flutter/material.dart';
import 'intrest_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _animation = Tween<double>(begin: 2.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InterestSelectionScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF213A50), Color(0xFF071938)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'The Daily',
                  style: TextStyle(
                    fontFamily: 'FontMain',
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Hour',
                  style: TextStyle(
                    fontFamily: 'FontMain',
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
