import 'package:flutter/material.dart';
import '../shared/strings.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(Strings.LOADING),
      ),
    );
  }
}
