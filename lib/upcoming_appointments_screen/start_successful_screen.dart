import 'dart:async';

import 'package:docudi/homescreen/homescreen.dart.dart';
import 'package:docudi/palette.dart';
import 'package:docudi/provider/dataProvider.dart';
import 'package:docudi/provider/user.dart';
import 'package:docudi/user_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartSuccessfulScreen extends StatefulWidget {
  static const routeName = "/success-start";

  @override
  State<StartSuccessfulScreen> createState() => _StartSuccessfulScreenState();
}

class _StartSuccessfulScreenState extends State<StartSuccessfulScreen> {
  Timer? timer;

  bool isLoading = false;

  Future<void> startAppt() async {
    print("helloo");
    var prov = Provider.of<DataProvider>(context, listen: false);
    print(prov.upcomingApptStart.toString());
    print(prov.scannedDoctorId);

    Map<String, dynamic> map = {
      "patientPfp": Provider.of<User>(context, listen: false).picture,
      "docID": prov.upcomingApptStart["doctorId"],
      "patientName": prov.upcomingApptStart["patientName"],
      "patientID": Provider.of<User>(context, listen: false).id,
      "date": prov.upcomingApptStart["date"],
      "time_slot": {
        "startTime": prov.upcomingApptStart["time"].toString().split(" - ")[0],
        "endTime": prov.upcomingApptStart["time"].toString().split(" - ")[1],
      },
      "symptoms": prov.upcomingApptStart["symptoms"].length == 0 ? " " : prov.upcomingApptStart["symptoms"],
    };
    print(map);
    try {
      await startAppointment(map);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error starting the appointment')),
      );
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }

  Future<void> checkEnd() async {
    var prov = Provider.of<DataProvider>(context, listen: false);
    Map<String, dynamic> map = {
      "patientID": Provider.of<User>(context, listen: false).id,
      "date": prov.upcomingApptStart["date"],
      "time_slot": {
        "startTime": prov.upcomingApptStart["time"].toString().split(" - ")[0],
        "endTime": prov.upcomingApptStart["time"].toString().split(" - ")[1],
      }
    };
    bool res = await checkActive(map);
    if (res == false) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }

  @override
  void initState() {
    startAppt();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => checkEnd());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: bgColor,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset("assets/images/success_start.png"),
                        ),
                      ],
                    ),
                    // Text(Provider.of<DataProvider>(context, listen: false).upcomingApptStart.toString()),
                    SizedBox(
                      height: 50,
                    ),
                    Text("Your doctor will end the appointment for you. Please refrain from moving away from this screen.")
                    // Container(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.of(context).pushNamed(HomeScreen.routeName);
                    //     },
                    //     style: ElevatedButton.styleFrom(elevation: 0),
                    //     child: Container(
                    //       width: double.infinity,
                    //       child: Center(
                    //         child: Text(
                    //           "End Appointment",
                    //           style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 15,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}
