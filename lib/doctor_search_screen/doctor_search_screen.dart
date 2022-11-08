import 'package:docudi/doctor_appointment_screen/doctor_appointment_screen.dart';
import 'package:docudi/palette.dart';
import 'package:docudi/provider/dataProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DoctorSearchScreen extends StatefulWidget {
  static const routeName = "/search";

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  TextEditingController searchController = new TextEditingController();
  List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  late String currDay;
  late List<dynamic> data;
  List<dynamic> temp = [];
  late var prov;

  void initialise() {
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('EEEE').format(date);
    currDay = dateFormat.substring(0, 3);

    prov = Provider.of<DataProvider>(context, listen: false);
    data = prov.searchResults;
    List t = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i]["city"] == prov.city) t.add(data[i]);
    }
    data = t;
    temp = data;
  }

  @override
  void initState() {
    initialise();
    super.initState();
  }

  void search() {
    data = temp;
    String txt = searchController.text;
    if (txt.length == 0) {
      data = temp;
    } else {
      data = temp;
      List<dynamic> t = [];
      data.forEach((element) {
        if (element["name"].toString().contains(txt) || element["name"].toString().toLowerCase().contains(txt)) {
          t.add(element);
        }
      });
      data = t;
    }
    setState(() {});
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
                        "List of Doctors",
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
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (_) => search(),
                        controller: searchController,
                        decoration: InputDecoration.collapsed(
                            hintText: "Search a doctor",
                            hintStyle: TextStyle(
                              fontSize: 12,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Days",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...days.map((e) => GestureDetector(
                        onTap: () {
                          // setState(() {
                          //   currDay = e;
                          // });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          // padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: currDay == e ? primaryColor : Colors.white,
                            borderRadius: BorderRadius.circular(360),
                          ),
                          child: Center(
                            child: Text(
                              e,
                              style: TextStyle(
                                color: currDay == e ? Colors.white : Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemCount: data.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                data[i]["pfp"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            data[i]["name"],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            data[i]["specialization"],
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset("assets/images/rs_symbol.png"),
                          Text(
                            "₹ " + data[i]["consultation_fee"],
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            height: 20,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: ElevatedButton(
                                  onPressed: () {
                                    prov.workingDays = data[i]["working_days"];
                                    prov.id = data[i]["_id"];
                                    prov.email = data[i]["email"];
                                    prov.clinicAddress = data[i]["clinic_address"];
                                    prov.docSpecialsation = data[i]["specialization"];
                                    prov.city = data[i]["city"];
                                    prov.timeSlots = data[i]["time_slots"];
                                    prov.fee = data[i]["consultation_fee"];
                                    prov.name = data[i]["name"];
                                    prov.picture = data[i]["pfp"];
                                    print(prov.workingDays.toString() + prov.id + prov.email + prov.clinicAddress + prov.docSpecialsation + prov.timeSlots.toString() + prov.city + prov.fee);
                                    Navigator.of(context).pushNamed(DoctorAppointmentScreen.routeName);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                  ),
                                  child: Text(
                                    "Fix appointment",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
