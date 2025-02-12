import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/screens/login_screen.dart';

class AccountScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id'); // ✅ Remove user session

    // Navigate to login screen and clear previous pages
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context), // ✅ Logout function
          child: Text("Logout"),
        ),
      ),
    );
  }
}
