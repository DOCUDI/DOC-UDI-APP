import 'package:docudi/doctor_search_screen/doctor_search_screen.dart';
import 'package:docudi/homescreen/sign_up_screen.dart';
import 'package:docudi/homescreen/upload_picture_screen.dart';
import 'package:docudi/palette.dart';
import 'package:docudi/previous_appointments_screen/previous_appointment_details_screen.dart';
import 'package:docudi/previous_appointments_screen/previous_appointments_screen.dart';
import 'package:docudi/provider/dataProvider.dart';
import 'package:docudi/provider/user.dart';
import 'package:docudi/symptoms_screen/symptoms_screen.dart';
import 'package:docudi/upcoming_appointments_screen/confirmed_appointments_screen.dart';
import 'package:docudi/upcoming_appointments_screen/upcoming_appointments_screen.dart';
import 'package:docudi/user_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var city = ["Select a city", "Kolkata", "Chennai", "Vellore", "Mumbai", "Delhi", "Agra"];
  var specialisation = ["Select a specialisation", "Cardiologist", "Gynaecologist", "Anesthesiologists", "Dermatologists", "Endocrinologists", "Gastroenterologists"];
  String cityValue = "Select a city";
  String specialisationValue = "Select a specialisation";
  bool isLoading = false;
  late var prov1;
  late var prov2;
  TextEditingController symptomController = new TextEditingController();

  Future<void> searchDocs() async {
    if (cityValue == "Select a city") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a city!')),
      );
      return;
    }
    if (specialisationValue == "Select a specialisation") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a specialisation!')),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      var prov = Provider.of<DataProvider>(context, listen: false);
      prov.specialisation = specialisationValue.toString().toLowerCase();
      prov.city = cityValue;
      prov.searchResults = [];
      var data = await getDoctors(prov.specialisation);
      if (symptomController.text.length != 0) prov.symptoms = symptomController.text.split(",");

      print(prov.symptoms.toString());
      if (data.length != 0) {
        prov.searchResults = data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sorry, no doctors found')),
        );
      }

      Navigator.of(context).pushNamed(DoctorSearchScreen.routeName).then((value) async {
        var res = await getUpcomingAppointments(prov1.id);
        prov2.initialiseUpcomingAppointments(res);
        res = await getPreviousAppointments(prov1.id);
        prov2.initialisePreviousAppointments(res);
        setState(() {
          isLoading = false;
        });
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('There was an error processing your request.')),
      );
    }
  }

  Future<void> initData() async {
    setState(() {
      isLoading = true;
    });

    await prov1.checkUser();
    bool res = await prov1.checkUserPicture();
    prov2.symptoms.clear();
    print(prov1.picture);
    if (!res) {
      Navigator.of(context).pushReplacementNamed(UploadPictureScreen.routeName);
    } else {
      try {
        var res = await getUpcomingAppointments(prov1.id);
        prov2.initialiseUpcomingAppointments(res);
        res = await getPreviousAppointments(prov1.id);
        prov2.initialisePreviousAppointments(res);
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('There was an error processing your request.')),
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    prov1 = Provider.of<User>(context, listen: false);
    prov2 = Provider.of<DataProvider>(context, listen: false);
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70,
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
                                prov1.picture,
                                fit: BoxFit.cover,
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi " + prov1.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "We hope you are doing good.",
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        TextButton(
                            onPressed: () async {
                              await prov1.logoutUser();
                              Navigator.of(context).pushNamedAndRemoveUntil("/homescreen", (route) => false);
                            },
                            child: Text("Log out"))
                        // Image.asset("assets/images/notification.png"),
                      ],
                    ),
                    prov2.upcomingAppointments.length != 0
                        ? SizedBox(
                            height: 20,
                          )
                        : SizedBox(),
                    prov2.upcomingAppointments.length != 0
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Upcoming Schedules",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 20,
                                child: TextButton(
                                    style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(UpcomingAppointmentsScreen.routeName);
                                    },
                                    child: Text(
                                      "See all",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: primaryColor,
                                      ),
                                    )),
                              ),
                            ],
                          )
                        : SizedBox(),
                    prov2.upcomingAppointments.length != 0
                        ? SizedBox(
                            height: 20,
                          )
                        : SizedBox(),
                    prov2.upcomingAppointments.length != 0
                        ? GestureDetector(
                            onTap: () {
                              Map<String, dynamic> map = {
                                "picture": prov2.upcomingAppointments[0]["docPfp"],
                                "doctorId": prov2.upcomingAppointments[0]["docID"],
                                "doctorName": prov2.upcomingAppointments[0]["docName"],
                                "fee": prov2.upcomingAppointments[0]["fees"],
                                "address": prov2.upcomingAppointments[0]["address"],
                                "symptoms": prov2.upcomingAppointments[0]["symptoms"],
                                "patientName": prov2.upcomingAppointments[0]["patientName"],
                                "date": prov2.upcomingAppointments[0]["date"],
                                "time": prov2.upcomingAppointments[0]["time_slot"]["startTime"] + " - " + prov2.upcomingAppointments[0]["time_slot"]["endTime"],
                                "specialisation": prov2.upcomingAppointments[0]["specialization"],
                              };
                              prov2.upcomingApptStart = map;
                              Navigator.of(context).pushNamed(ConfirmedAppointmentScreen.routeName).then((value) {
                                initData();
                              });
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: 42,
                                  left: 20,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      // margin: EdgeInsets.symmetric(horizontal: 20),
                                      height: 100,
                                      width: 310,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromRGBO(150, 187, 255, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 35,
                                  left: 10,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      // margin: EdgeInsets.symmetric(horizontal: 20),
                                      height: 100,
                                      width: 330,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromRGBO(119, 167, 255, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              prov2.upcomingAppointments[0]["docName"],
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              prov2.upcomingAppointments[0]["specialization"],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset("assets/images/calendar.png"),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  DateFormat("dd MMMM").format(DateTime.parse(prov2.upcomingAppointments[0]["date"])) + " " + prov2.upcomingAppointments[0]["time_slot"]["startTime"] + " - " + prov2.upcomingAppointments[0]["time_slot"]["endTime"],
                                                  style: TextStyle(
                                                    color: primaryFontColor,
                                                    fontSize: 12,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                          height: 70,
                                          width: 70,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(360),
                                            child: Image.network(
                                              prov2.upcomingAppointments[0]["docPfp"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          )
                        : SizedBox(),
                    prov2.upcomingAppointments != 0
                        ? SizedBox(
                            height: 50,
                          )
                        : SizedBox(),
                    Text(
                      "Schedule an appointment",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      // height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/city.png",
                            height: 15,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                // Initial Value
                                value: cityValue,
                                isExpanded: true,
                                elevation: 0,
                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                // Array list of items
                                items: city.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    cityValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      // height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/specialisation.png",
                            height: 15,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: specialisationValue,
                                isExpanded: true,
                                elevation: 0,
                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: specialisation.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    specialisationValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: symptomController,
                        // onChanged: (_) => search(),
                        decoration: InputDecoration.collapsed(
                            hintText: "Enter your symptoms",
                            hintStyle: TextStyle(
                              fontSize: 16,
                            )),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not sure about which specialisation to choose?\nTell us your symptoms.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        )),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(SymptomsScreen.routeName).then((value) {
                            setState(() {
                              symptomController.text = prov2.symptoms.toString().substring(1, prov2.symptoms.toString().length - 1);
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(elevation: 0),
                        child: Container(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "Select Symptoms",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          searchDocs();
                        },
                        style: ElevatedButton.styleFrom(elevation: 0),
                        child: Container(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "Search",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (prov2.previousAppointments.length != 0)
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Previous Appointments",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 20,
                                child: TextButton(
                                    style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(PreviousAppointmentsScreen.routeName);
                                    },
                                    child: Text(
                                      "See all",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: primaryColor,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              return GestureDetector(
                                onTap: () {
                                  Map<String, dynamic> map = {
                                    "specialisation": prov2.previousAppointments[i]["specialization"],
                                    "doctorName": prov2.previousAppointments[i]["docName"],
                                    "patientName": prov2.previousAppointments[i]["patientName"],
                                    "date": prov2.previousAppointments[i]["date"],
                                    "time": prov2.previousAppointments[i]["time"],
                                    "address": prov2.previousAppointments[i]["clinicAddress"],
                                    "picture": prov2.previousAppointments[i]["docPfp"],
                                    // "symptoms": data[i]["symptoms"],
                                    "fee": prov2.previousAppointments[i]["fees"],
                                    "prescription": prov2.previousAppointments[i]["prescription"],
                                  };
                                  prov2.previousApptDetails = map;
                                  Navigator.of(context).pushNamed(PreviousAppointmentDetailsScreen.routeName);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                                  margin: EdgeInsets.only(bottom: 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            prov2.previousAppointments[i]["docName"],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            prov2.previousAppointments[i]["specialization"],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/calendar.png",
                                            height: 15,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            DateFormat("dd MMMM").format(DateTime.parse(prov2.previousAppointments[i]["date"])),
                                            style: TextStyle(
                                              color: primaryFontColor,
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: prov2.previousAppointments.length > 3 ? 3 : prov2.previousAppointments.length,
                          )
                        ],
                      )
                  ],
                ),
              ),
            ),
    );
  }
}
