import 'package:docudi/palette.dart';
import 'package:docudi/provider/dataProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PreviousAppointmentDetailsScreen extends StatefulWidget {
  static const routeName = "/history-details";

  @override
  State<PreviousAppointmentDetailsScreen> createState() => PreviousAppointmentDetailsScreenState();
}

class PreviousAppointmentDetailsScreenState extends State<PreviousAppointmentDetailsScreen> {
  late Map<String, dynamic> data;
  late var prov;

  @override
  void initState() {
    prov = Provider.of<DataProvider>(context, listen: false);
    data = prov.previousApptDetails;
    // TODO: implement initState
    super.initState();
  }

  @override
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
                        "Previous appointments",
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
                        data["picture"],
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
                          data["doctorName"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          data["specialisation"],
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          width: 250,
                          child: Text(
                            data["address"],
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
                  label("Patient's name: ", data["patientName"]),
                  SizedBox(
                    height: 20,
                  ),
                  label("Date: ", DateFormat("dd MMMM, yyyy").format(DateTime.parse(data["date"])).toString()),
                  SizedBox(
                    height: 20,
                  ),
                  label("Time: ", data["time"]["startTime"] + " - " + data["time"]["endTime"]),
                  SizedBox(
                    height: 20,
                  ),
                  label("Address: ", data["address"]),
                  SizedBox(
                    height: 20,
                  ),
                  // // label("Symptoms: ", "Cough, fever and dizziness"),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  label("Consultation fee: ", "₹ " + data["fee"]),
                  SizedBox(
                    height: 20,
                  ),
                  label("Prescription details: ", data["prescription"]),
                ],
              ),
              SizedBox(
                height: 20,
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
