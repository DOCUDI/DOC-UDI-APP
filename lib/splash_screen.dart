import 'dart:async';
import 'package:docudi/homescreen/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(88, 147, 255, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      color: Color.fromRGBO(0, 18, 51, 0.3),
                    ),
                    BoxShadow(
                      offset: Offset(2, 4),
                      blurRadius: 10,
                      color: Color.fromRGBO(0, 18, 51, 0.3),
                    )
                  ],
                  color: Color.fromRGBO(76, 129, 226, 1),
                ),
                child: Column(
                  children: [
                    Image.asset("assets/images/doctor.png"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "DocUPI",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          CupertinoActivityIndicator(
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
