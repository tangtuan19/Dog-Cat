import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';
import 'classifier.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  final Classifier _classifier = Classifier();
  @override
  void initState() {
    super.initState();
    _initializeModel();
  }
  Future<void> _initializeModel() async {
    await _classifier.init();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen(classifier: _classifier)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.pets, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text("Cat vs Dog Detector", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
