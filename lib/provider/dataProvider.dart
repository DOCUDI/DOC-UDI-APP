import 'package:flutter/cupertino.dart';

class DataProvider with ChangeNotifier {
  String selectedCity = "";

  String specialisation = "";
  List<dynamic> searchResults = [];

  Map<String, dynamic> appointmentBook = {};

  List<dynamic> workingDays = [];
  String? id = "";
  String? name = "";
  String? email = "";
  String? clinicAddress = "";
  String? docSpecialsation = "";
  String? city = "";
  String? picture = "";
  List<dynamic> timeSlots = [];
  String? fee = "";
  List<String> symptoms = [];

  List<dynamic> upcomingAppointments = [];
  List<dynamic> previousAppointments = [];

  void initialiseUpcomingAppointments(List<dynamic> appts) {
    upcomingAppointments = appts;
    upcomingAppointments.sort((a, b) {
      return a["date"].compareTo(b["date"]);
    });
  }

  void initialisePreviousAppointments(List<dynamic> appts) {
    previousAppointments = appts;
    previousAppointments.sort((a, b) {
      return b["date"].compareTo(a["date"]);
    });
  }

  Map<String, dynamic> upcomingApptStart = {};

  String scannedDoctorId = "";

  Map<String, dynamic> previousApptDetails = {};
}
