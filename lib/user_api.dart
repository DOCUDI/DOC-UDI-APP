import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> signInPost(String name, String email, String password) async {
  final String url = "https://docudibackend.herokuapp.com/api/user/create-user";
  final response = await http.post(
    Uri.parse(url),
    body: {
      "name": name,
      "email": email,
      "password": password,
      "pfp": "",
    },
  );
  print(response.body);
  var data = jsonDecode(response.body);
  if (data["success"] == false) {
    if (data["message"] == "This email is already in use, try sign-in") {
      throw "existing email";
    } else
      throw "other";
  } else {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      "picture": "",
      "id": data["user"]["_id"],
      "token": "",
      "name": data["user"]["name"],
      "email": data["user"]["email"],
    });
    print(userData);
    prefs.setString("userData", userData);
  }
}

Future<void> login(String email, String password) async {
  // print(email);
  final String url = "https://docudibackend.herokuapp.com/api/user/sign-in";
  final response = await http.post(
    Uri.parse(url),
    body: {
      "email": email,
      "password": password,
    },
  );
  print(response.body);
  var data = jsonDecode(response.body);
  if (data["success"] == false) {
    throw data["message"];
  } else {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      "picture": data["user"]["pfp"],
      "id": data["id"],
      "token": data["token"],
      "name": data["user"]["fullname"],
      "email": data["user"]["email"],
    });
    print(userData);
    prefs.setString("userData", userData);
  }
}

Future<void> bookAppointment(Map<String, dynamic> dataAppt) async {
  final String url = "https://docudibackend.herokuapp.com/api/user/book-appointment";

  var postData = json.encode(dataAppt);
  print(postData);
  final response = await http.post(Uri.parse(url), body: postData, headers: {"content-type": "application/json"});
  print(response.body);
  var data = json.decode(response.body);
  if (data["success"] == false) {
    throw "err";
  }
}

Future<List<dynamic>> getDoctors(String specs) async {
  final String url = "https://docudibackend.herokuapp.com/api/user/get-doc-specialization";
  final response = await http.post(
    Uri.parse(url),
    body: {
      "specialization": specs,
    },
  );
  var res = json.decode(response.body);
  print(res);
  if (res["success"] == true) {
    return res["docs"];
  } else {
    throw "err";
  }
  return [];
}

Future<List<dynamic>> getUpcomingAppointments(String id) async {
  final String url = "https://docudibackend.herokuapp.com/api/user/upcoming-appointment";
  print("ID: " + id);
  final response = await http.post(
    Uri.parse(url),
    body: {
      "id": id,
    },
  );
  print(response.body);
  var res = json.decode(response.body);
  // print(res);
  if (res["success"] == true) {
    return res["upAppointments"];
  }
  return [];
}

Future<List<dynamic>> getPreviousAppointments(String id) async {
  final String url = "https://docudibackend.herokuapp.com/api/user/previous-appointment";
  final response = await http.post(
    Uri.parse(url),
    body: {
      "patientID": id,
    },
  );
  var res = json.decode(response.body);
  print(res);
  if (res["success"] == true) {
    return res["medicalHistory"];
  }
  return [];
}

Future<void> startAppointment(Map<String, dynamic> map) async {
  final String url = "https://docudibackend.herokuapp.com/api/user/start-appointment";
  var postData = json.encode(map);
  final response = await http.post(
    Uri.parse(url),
    body: postData,
    headers: {"content-type": "application/json"},
  );
  var res = json.decode(response.body);
  print(res);
  if (res["success"] == false) {
    throw "err";
  }
}

Future<bool> checkActive(Map<String, dynamic> map) async {
  final String url = "https://docudibackend.herokuapp.com/api/user/end-appointment";
  var postData = json.encode(map);
  final response = await http.post(
    Uri.parse(url),
    body: postData,
    headers: {"content-type": "application/json"},
  );
  var res = json.decode(response.body);
  print(postData.toString());
  print(res);
  if (res["success"] == false) {
    return false;
  }
  return true;
}

Future<String> predictDisease(List<String> symptoms) async {
  final String url = "https://doc-udi-disease-predictor.herokuapp.com/predict";
  var postData = json.encode({
    "id": "123",
    "diseases": symptoms,
  });
  final response = await http.post(
    Uri.parse(url),
    body: postData,
    headers: {"content-type": "application/json"},
  );
  var res = json.decode(response.body);
  // print(postData.toString());
  print(res);
  return res["predicted_disease"];
  // if (res["success"] == false) {
  //   return false;
  // }
  // return true;
}

Future<void> uploadPhoto(String purl, String id) async {
  final String url = "https://docudibackend.herokuapp.com/api/user/update-pfp";
  final response = await http.post(
    Uri.parse(url),
    body: {
      "id": id,
      "pfp": purl,
    },
  );
  var res = json.decode(response.body);
  print(res);
}
