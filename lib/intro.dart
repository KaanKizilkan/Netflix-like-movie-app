import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:yeni/video.dart';
import 'package:yeni/widget_tree.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: Video(),
      duration: 2600,
      backgroundColor: Colors.black,
      screenFunction: () async {
        return Tree();
      },
      splashIconSize: 1000,
    );
  }
}
