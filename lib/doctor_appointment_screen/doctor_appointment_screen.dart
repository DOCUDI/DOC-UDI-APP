import 'package:docudi/doctor_appointment_screen/confirm_appointment_screen.dart';
import 'package:docudi/palette.dart';
import 'package:docudi/provider/dataProvider.dart';
import 'package:docudi/provider/user.dart';
import 'package:docudi/user_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  static const routeName = "/book";

  @override
  State<DoctorAppointmentScreen> createState() => _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen> {
  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  List<dynamic> availableDays = [];
  late List<dynamic> slots;

  DateTime bookingDay = DateTime.now();
  late var prov1;
  late var prov2;

  late String doctorName;
  late String pfp;
  late String pic;
  late String doctorID;
  late String specialisation;
  late String patientName;
  late String patientID;
  late String startTime;
  late String endTime;
  late String fee;
  late String address;
  late List<String> symptoms;

  bool isLoading = false;
  int selectedSlot = -1;

  void initialise() {
    setState(() {
      isLoading = true;
    });
    prov1 = Provider.of<DataProvider>(context, listen: false);
    prov2 = Provider.of<User>(context, listen: false);
    doctorName = prov1.name;
    doctorID = prov1.id;
    pfp = prov1.picture;
    pic = prov2.picture;
    specialisation = prov1.docSpecialsation;
    patientName = prov2.name;
    patientID = prov2.id;
    slots = prov1.timeSlots;
    fee = prov1.fee;
    address = prov1.clinicAddress;
    symptoms = prov1.symptoms;
    for (int i = 0; i < prov1.workingDays.length; i++) {
      availableDays.add(prov1.workingDays[i]);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    initialise();
    super.initState();
  }

  void bookAppt() {
    if (selectedSlot == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a slot!')),
      );
      return;
    }
    Map<String, dynamic> data = {
      "docPfp": pfp,
      "patientPfp": pic,
      "docName": doctorName,
      "docID": doctorID,
      "specialization": specialisation,
      "patientName": patientName,
      "patientID": patientID,
      "fees": fee,
      "address": address,
      "symptoms": symptoms.isEmpty ? " " : symptoms,
      "date": bookingDay.toString(),
      "time_slot": {
        "startTime": slots[selectedSlot]["startTime"],
        "endTime": slots[selectedSlot]["endTime"],
      }
    };
    Provider.of<DataProvider>(context, listen: false).appointmentBook = data;
    Navigator.of(context).pushNamed(ConfirmAppointmentScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: !isLoading
          ? SingleChildScrollView(
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
                              "Select Date and Time",
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
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
                              prov1.picture,
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
                                doctorName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                specialisation,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Container(
                                width: 250,
                                child: Text(
                                  prov1.clinicAddress + ", " + prov1.city,
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
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Working days",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...days.map((e) => Container(
                                  width: 40,
                                  height: 40,
                                  // padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: availableDays.contains(e) ? Colors.white : Color.fromRGBO(245, 245, 245, 1),
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: Center(
                                    child: Text(
                                      e.substring(0, 3),
                                      style: TextStyle(
                                        color: availableDays.contains(e) ? Colors.black : Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Consultation fee: ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "₹ " + prov1.fee,
                            style: TextStyle(
                              fontSize: 15,
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
                        Container(
                          child: Text(
                            "Time slots: ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3.5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: slots.length,
                          itemBuilder: (ctx, i) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSlot = i;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedSlot == i ? primaryColor : Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(slots[i]["startTime"] + " - " + slots[i]["endTime"]),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Select date: ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                            child: TableCalendar(
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              // borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )),
                          currentDay: bookingDay,
                          onDaySelected: (DateTime x, DateTime y) {
                            print(x);
                            setState(() {
                              bookingDay = x;
                            });
                          },
                          firstDay: DateTime.now(),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: bookingDay,
                          // calendarStyle: ,
                        )),
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
                            // print(availableDays.toString());
                            if (!availableDays.contains(DateFormat("EEEE").format(bookingDay).toString()))
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Doctor not available on the selected day!')),
                              );
                            else
                              // bookingDay.
                              bookAppt();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            child: Center(
                              child: Text(
                                "Book Appointment",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
