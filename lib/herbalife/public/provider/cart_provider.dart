import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project2/herbalife/public/model/cart_model.dart';
import 'package:project2/herbalife/public/provider/data_provider.dart';
import 'package:project2/herbalife/public/constants/constants.dart';
import 'dart:convert';

class CartProvider extends ChangeNotifier {
  final SecureStorageProvider dataProvider = SecureStorageProvider();

  String? message;
  bool isLoading = false;
  String? userToken;
  String? id;
  int? invoiceId;
  int cartCount = 0;
  List<CartItemModel> cartItems = [];
  Map<int, int> productInvoiceMap = {};

  void saveInvoiceId(int productId, int invoiceId) {
    productInvoiceMap[productId] = invoiceId;
    notifyListeners();
  }

  int? getInvoiceId(int productId) => productInvoiceMap[productId];

  void clearInvoiceId(int productId) {
    productInvoiceMap.remove(productId);
    notifyListeners();
  }

  Future<void> fetchCartItems() async {
    isLoading = true;
    notifyListeners();
    try {
      id ??= await dataProvider.readSecureData('id');
      userToken ??= await dataProvider.readSecureData('token');
      final response = await http.get(
        Uri.parse('$accounturl/getitem/$id'),
        headers: {'Authorization': 'Bearer ${userToken ?? ""}'},
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        final cart = CartModel.fromJson(data);
        cartItems = cart.data;
        message = cart.message;
      } else {
        cartItems = [];
        message = data['message'];
      }
    } catch (e) {
      message = "Network error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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
        await fetchCartItems();
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
        await fetchCartItems();
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
        await fetchCartItems();
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
}