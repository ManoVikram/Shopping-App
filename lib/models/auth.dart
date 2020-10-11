import 'dart:convert';
import 'dart:io';
import 'dart:async'; // Allows access to 'Timer'

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './httpException.dart';

class Auth with ChangeNotifier {
  String _token; // This token expires after some time for security measures.
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBswHNLkOkr3LCp_ZAI2o0v8CgYmZ0Z7u0";
    // [API_KEY] - Steps - Gear icon -> Project Settings -> Web API key
    try {
      // Validation errors aren't thrown by 'post'
      // Validation errors doesn't have error status code.
      final response = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      print(json.decode(response.body));

      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }

      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData["expiresIn"],
          ),
        ),
      );
      // 'responseData["expiresIn"]' is a String. It is necessary to convert it into an integer.
      _autoLogOut();
      notifyListeners();

      // Working with 'SharedPreferences' involves working with 'Futures'
      // Thus, 'async' and 'await' are required.
      final preferences = await SharedPreferences.getInstance();
      // Kind of tunnel to on-device storage
      final userData = json.encode(
        {
          "token": _token,
          "userId": _userId,
          "expiryDate": _expiryDate.toIso8601String(),
        },
      );
      preferences.setString("userData", userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogIn() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey("userData")) {
      return false;
    }

    final extractedUserData =
        json.decode(preferences.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogOut();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    // preferences.remove("userData"); -> Removes only the 'userData'
    preferences.clear(); // Clears/Removes everything
    // Prevents from auto logging in when the expiry date < current date
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeLeftToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeLeftToExpire), logOut);
  }
}
