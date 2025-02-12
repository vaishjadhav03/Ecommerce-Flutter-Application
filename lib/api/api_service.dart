//api_service.dart ->
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/models/product_model.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2/ecommerce_api/";

  // Fetch all products
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}get_products.php"));
      print("Response: ${response.body}");  // Log the response to see what is returned

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // If no products are returned, log a warning and return an empty list
        if (data.isEmpty) {
          print("Warning: No products found in the response.");
        }

        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        print("Failed to load products. Status code: ${response.statusCode}");
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to load products');
    }
  }

  // Place order function
  Future<bool> placeOrder(int userId, List<Product> cartItems) async {
    try {
      final url = Uri.parse("${baseUrl}save_order.php");

      // Convert cart items into JSON format
      List<Map<String, dynamic>> cartJson = cartItems.map((product) {
        return {
          "product_id": product.id,
          "stock": product.stock,
        };
      }).toList();

      // Prepare the request body
      final body = jsonEncode({
        "user_id": userId, // Getting user_id from SharedPreferences later
        "cart": cartJson,
      });

      // Send POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      // Parse the response
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        return true; // Order placed successfully
      } else {
        print("Order failed: ${responseData['message']}");
        return false;
      }
    } catch (e) {
      print("Error placing order: $e");
      return false;
    }
  }


  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${baseUrl}login.php"),
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Login API Response: $data"); // ✅ Debugging: Print the full response

      if (data['status'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', data['user_id'].toString());
        await prefs.setString('user_name', data['name']); // ✅ Store user name

        print("Stored User ID: ${prefs.getString('user_id')}");
        print("Stored User Name: ${prefs.getString('user_name')}"); // ✅ Debugging

        return true;
      }
    } else {
      print("Failed to login: ${response.body}"); // Print error response if login fails
    }
    return false;
  }

  // Signup function
  Future<bool> signup(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}register.php"),
        body: {"name": name, "email": email, "password": password},
      );

      final data = jsonDecode(response.body);
      print("Signup API Response: $data"); // Debugging API response

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle response correctly
        if (data['status'].toLowerCase() == 'success') {
          return true;
        } else {
          print("Signup failed: ${data['message']}");
          return false;
        }
      } else {
        print("Unexpected response code: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Signup error: $e");
      return false;
    }
  }

}
