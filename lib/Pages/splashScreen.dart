import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gpgroup/Pages/Home.dart';
import 'package:gpgroup/Wrapper.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isHome = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valueChange();
  }
  void valueChange(){
    Timer(Duration(seconds: 3), (){
      setState(() {
        isHome = true;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return isHome?Wrapper(): Scaffold(
      body: Center(child: Image.asset('assets/vrajraj.png')),
    );
  }
}
