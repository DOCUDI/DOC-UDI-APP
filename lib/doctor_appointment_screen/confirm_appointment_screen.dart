import 'package:docudi/doctor_appointment_screen/appointment_success_screen.dart';
import 'package:docudi/palette.dart';
import 'package:docudi/provider/dataProvider.dart';
import 'package:docudi/user_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfirmAppointmentScreen extends StatefulWidget {
  static const routeName = "/confirm";

  @override
  State<ConfirmAppointmentScreen> createState() => _ConfirmAppointmentScreenState();
}

class _ConfirmAppointmentScreenState extends State<ConfirmAppointmentScreen> {
  late var prov;
  late Map<String, dynamic> data;
  bool isLoading = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await bookAppointment(data);
      Navigator.of(context).pushNamed(AppointmentSuccessScreen.routeName);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error scheduling appointment. Please try again later')),
      );
      Navigator.of(context).pop();
    }
    print(data);
  }

  @override
  void initState() {
    prov = Provider.of<DataProvider>(context, listen: false);
    data = prov.appointmentBook;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
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
                              "Confirm your appointment",
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
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label("Doctor's name: ", prov.name),
                        SizedBox(
                          height: 20,
                        ),
                        label("City: ", prov.city),
                        SizedBox(
                          height: 20,
                        ),
                        label("Specialization: ", prov.specialisation),
                        SizedBox(
                          height: 20,
                        ),
                        label("Address: ", prov.clinicAddress),
                        SizedBox(
                          height: 20,
                        ),
                        label(
                          "Date: ",
                          DateFormat('dd-MM-yyyy').format(DateTime.parse(data["date"])),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        label("Time: ", data["time_slot"]["startTime"] + " - " + data["time_slot"]["endTime"]),
                        SizedBox(
                          height: 20,
                        ),
                        label("Symptoms: ", prov.symptoms.length == 0 ? "None" : prov.symptoms.toString().substring(1, prov.symptoms.toString().length - 1)),
                        SizedBox(
                          height: 20,
                        ),
                        label("Consultation fee: ", "₹ " + prov.fee),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () {
                            getData();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            child: Center(
                              child: Text(
                                "Confirm Appointment",
                                style: TextStyle(
                                  color: Colors.white,
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
