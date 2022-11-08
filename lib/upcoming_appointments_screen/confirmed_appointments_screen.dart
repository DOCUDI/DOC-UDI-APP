import 'package:docudi/palette.dart';
import 'package:docudi/provider/dataProvider.dart';
import 'package:docudi/upcoming_appointments_screen/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfirmedAppointmentScreen extends StatefulWidget {
  static const routeName = "/confirmed-appointments";

  @override
  State<ConfirmedAppointmentScreen> createState() => _ConfirmedAppointmentScreenState();
}

class _ConfirmedAppointmentScreenState extends State<ConfirmedAppointmentScreen> {
  @override
  late var prov;

  @override
  void initState() {
    prov = Provider.of<DataProvider>(context, listen: false);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text(
                        "Appointments",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(360),
                      color: Colors.amber,
                    ),
                    height: 60,
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.network(
                        prov.upcomingApptStart["picture"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prov.upcomingApptStart["doctorName"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          prov.upcomingApptStart["specialisation"],
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          width: 250,
                          child: Text(
                            prov.upcomingApptStart["address"],
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Appointment Details",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label("Patient's name: ", prov.upcomingApptStart["patientName"]),
                  SizedBox(
                    height: 20,
                  ),
                  label("Date: ", DateFormat("dd MMMM, yyyy").format(DateTime.parse(prov.upcomingApptStart["date"]))),
                  SizedBox(
                    height: 20,
                  ),
                  label("Time: ", prov.upcomingApptStart["time"]),
                  SizedBox(
                    height: 20,
                  ),
                  label("Address: ", prov.upcomingApptStart["address"]),
                  SizedBox(
                    height: 20,
                  ),
                  label("Symptoms: ", prov.upcomingApptStart["symptoms"].length == 0 ? "None" : prov.upcomingApptStart["symptoms"].toString().substring(1, prov.upcomingApptStart["symptoms"].toString().length - 1)),
                  SizedBox(
                    height: 20,
                  ),
                  label("Consultation fee: ", prov.upcomingApptStart["fee"]),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CameraScreen.routeName);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      child: Center(
                        child: Text(
                          "Start Appointment",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column label(String heading, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: primaryFontColor,
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          val,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
