import 'package:flutter/material.dart';
import 'package:yeni/auth.dart';
import 'package:yeni/main.dart';
import 'package:yeni/login_register.dart';

class Tree extends StatefulWidget {
  const Tree({super.key});

  @override
  State<Tree> createState() => _TreeState();
}

class _TreeState extends State<Tree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:Auth().authStateChanges ,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          
          return MyHomePage();
        }else{
          return LogRegpage();
        }
      },
    );
  }
}

