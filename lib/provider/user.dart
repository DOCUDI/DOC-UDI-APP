import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  String? token;
  String? name;
  String? email;
  String? id;
  String? picture;

  bool get isAuth {
    return token != null;
  }

  Future<bool> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print("NOOO");
      return false;
    } else {
      print("YES");
      final extractedUserData = json.decode(prefs.getString('userData').toString()) as Map<String, dynamic>;
      id = extractedUserData["id"];
      token = extractedUserData["token"];
      name = extractedUserData["name"];
      email = extractedUserData["email"];
      picture = extractedUserData["picture"];

      notifyListeners();
      return true;
    }
  }

  Future<bool> checkUserPicture() async {
    final prefs = await SharedPreferences.getInstance();

    final extractedUserData = json.decode(prefs.getString('userData').toString()) as Map<String, dynamic>;
    id = extractedUserData["id"];
    token = extractedUserData["token"];
    name = extractedUserData["name"];
    email = extractedUserData["email"];
    picture = extractedUserData["picture"];

    if (picture == "") return false;
    return true;
  }

  Future<void> updatePicture(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      "picture": url,
      "id": id,
      "token": token,
      "name": name,
      "email": email,
    });
    print(userData);
    prefs.setString("userData", userData);
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
  }
}
