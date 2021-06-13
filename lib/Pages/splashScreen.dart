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
    return
     isHome?Wrapper():
    Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:20.0,horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Image.asset('assets/vrajraj.png')),
              // RichText(
              //   text: TextSpan(children: [
              //     TextSpan(
              //         text: 'Developed by',
              //         style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 25,
              //         )),
              //
              //     WidgetSpan(
              //       child: Transform.translate(
              //         offset: const Offset(-8, 20),
              //         child: Text(
              //           'J&A',
              //           //superscript is usually smaller in size
              //
              //           textScaleFactor: 2,
              //           style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
              //         ),
              //       ),
              //     )
              //   ]),
              // )

            ],
          ),
        ),
      )
    );
  }
}
