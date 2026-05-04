import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project2/herbalife/public/provider/data_provider.dart';
import 'package:project2/herbalife/public/constants/constants.dart';

class Authprovider extends ChangeNotifier {
  final SecureStorageProvider dataProvider = SecureStorageProvider();
  String? message;
  bool isLoading = false;
  String? userToken;
  String? userId; // Store as String (Member ID)
  String? id; // Store as String (Database Primary Key)
  File? image;
  double totalPoints = 0;

  String get isUserid => userId ?? "No id";

  //
  Future<void> login(String userid, String password) async {
    message = "";
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse("$accounturl/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userid': userid, 'password': password}),
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        message = data['message'];
        userToken = data['token'];
        // Safely convert to String in case they are integers in the DB
        userId = data['userid']?.toString();
        id = data['id']?.toString();
      } else {
        message = data['message'];
        userToken = null;
      }
    } catch (e) {
      message = "Login failed: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }





  Future<void> register(
    String name,
    String address,
    String phone,
    String email,
    File image,
  ) async {
    message = "";
    isLoading = true;
    notifyListeners();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$accounturl/register"),
      );
      request.fields['name'] = name;
      request.fields['address'] = address;
      request.fields['phone'] = phone;
      request.fields['email'] = email;

      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        message = "successfully";
        userId = data['userid']?.toString();
      } else {
        message = data['error'] ?? data['message'] ?? "Registration failed";
      }
    } catch (e) {
      message = "Network failed: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register2(int userid, int password, int userids) async {
    message = "";
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse("$accounturl/register2"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userid': userid,
          'password': password,
          'userids': userids,
        }),
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        message = data['message'];
        userId = data['userids']?.toString();
      } else {
        message = data['message'];
      }
    } catch (e) {
      message = "Network failed";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
