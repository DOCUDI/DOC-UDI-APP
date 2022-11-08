import 'dart:async';

import 'package:docudi/palette.dart';
import 'package:docudi/provider/dataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentSuccessScreen extends StatefulWidget {
  static const routeName = "/success";

  @override
  State<AppointmentSuccessScreen> createState() => _AppointmentSuccessScreenState();
}

class _AppointmentSuccessScreenState extends State<AppointmentSuccessScreen> {
  void startTimer() {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
    });
  }

  @override
  void initState() {
    startTimer();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset("assets/images/success.png"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
