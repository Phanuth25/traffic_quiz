import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project2/herbalife/public/model/cart_model.dart';
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
  int cartCount = 0;
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

  // Profile data
  String? email;
  String? phone;
  String? address;
  String? name;
  String? point;
  String? position;
  String? discount;
  String? photo;
  String? TotalPoint;
  String? TotalAmount;
  int? invoiceId;

  String get isemail => email ?? "No data";

  String get isphone => phone ?? "No data";

  String get isaddress => address ?? "No data";

  String get isname => name ?? "No data";

  String get ispoint => point ?? "No data";

  String get isposition => position ?? "No data";

  String get isdiscount => discount ?? "No data";

  Future<void> getProfile() async {
    message = "";
    isLoading = true;
    notifyListeners();

    try {
      // Restore state from secure storage if variables are null (e.g. after app restart)
      id ??= await dataProvider.readSecureData('id');
      userToken ??= await dataProvider.readSecureData('token');

      if (id == null) {
        message = "No user ID found";
        return;
      }

      final response = await http.get(
        Uri.parse("$accounturl/profile/$id"),
        headers: {'Authorization': 'Bearer ${userToken ?? ""}'},
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        id = data['id']?.toString();
        message = data['message'] ?? "Profile loaded";
        email = data['email'];
        phone = data['phone']?.toString();
        address = data['address'];
        name = data['name'];
        point = data['point']?.toString();
        position = data['position']?.toString();
        discount = data['discount']?.toString();
        photo = data['photo'];
      } else {
        message = data['message'] ?? "Failed to load profile";
      }
    } catch (e) {
      message = "Network error $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  // In your auth provider
  Map<int, int> productInvoiceMap = {};

  // { productId: invoiceId }

  void saveInvoiceId(int productId, int invoiceId) {
    productInvoiceMap[productId] = invoiceId;
    notifyListeners();
  }
  // Other methods...
  Future<void> postitem(int userid, int product, int quantity) async {
    message = "";
    invoiceId = null;
    try {
      final response = await http.post(
        Uri.parse("$accounturl/postitem"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userid': userid,
          'product': product,
          'quantity': quantity,
        }),
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        message = data['message'];
        invoiceId = data['invoiceId'];
        saveInvoiceId(product, invoiceId!);
        await fetchCartItems(); // ← just re-fetch everything
      } else {
        message = data['message'];
        invoiceId = null;
      }
    } catch (e) {
      message = "Network failed: $e";
      invoiceId = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  int? getInvoiceId(int productId) {
    return productInvoiceMap[productId];
  }
  void clearInvoiceId(int productId) {
    productInvoiceMap.remove(productId);
    notifyListeners();
  }

  Future<void> postitem2(int invoiceid, int quantity) async {
    message = "";
    invoiceId = null;
    try {
      final response = await http.patch(
        Uri.parse("$accounturl/postquantity"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'invoiceid': invoiceid, 'quantity': quantity}),
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        message = data['message'];
        await fetchCartItems(); // ← just re-fetch everything
      } else {
        message = data['message'];
      }
    } catch (e) {
      message = "Network failed: $e";
      invoiceId = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteitem(int invoiceId) async {
    message = "";
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.delete(
        Uri.parse("$accounturl/deleteitem/$invoiceId"),
        headers: {'Content-Type': 'application/json'},
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        message = data['message'];
        print(data);
         await fetchCartItems(); // ← just re-fetch everything
      } else {
        message = data['message'];
      }
    } catch (e) {
      message = "Network failed: $e";
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

  List<CartItemModel> cartItems = [];

  Future<void> fetchCartItems() async {
    isLoading = true;
    notifyListeners();
    try {
      id ??= await dataProvider.readSecureData('id');
      print(id);
      userToken ??= await dataProvider.readSecureData('token');

      final response = await http.get(
        Uri.parse('$accounturl/getitem/$id'),
        headers: {'Authorization': 'Bearer ${userToken ?? ""}'},
      );

      final data = json.decode(response.body);
      print("API Response: $data"); // Check if 'data' array has items
      if (response.statusCode == 200) {
        print(data);
        final cart = CartModel.fromJson(data);
        cartItems = cart.data;
        message = cart.message;
      } else {
        cartItems = []; // ← add this
        message = data['message'];
      }
    } catch (e) {
      message = "Network error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
