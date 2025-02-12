import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // ✅ Import PDF Viewer package
import '../controllers/cart_controller.dart';
import '../models/product_model.dart';
import '../services/location_service.dart';
import '../utils/pdf_invoice.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: Obx(() {
        final cartItems = cartController.cartItems.values.toList();
        return cartItems.isEmpty
            ? Center(child: Text("Cart is empty"))
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  Product product = cartItems[index];
                  return ListTile(
                    leading: Image.network(product.image, width: 50, height: 50),
                    title: Text(product.name),
                    subtitle: Text("\$${product.price.toInt()}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => cartController.decreaseQuantity(product.id),
                        ),
                        Text("${product.quantity}", style: TextStyle(fontSize: 16)),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => cartController.increaseQuantity(product.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Total: \$${cartController.totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String? userIdString = prefs.getString('user_id');

                      print("🔍 Stored user_id: $userIdString");

                      if (userIdString == null || userIdString.isEmpty || int.tryParse(userIdString) == null) {
                        Get.snackbar("Error", "User not logged in!");
                        return;
                      }

                      int userId = int.parse(userIdString);
                      String address = await LocationService.getCurrentLocation();
                      double totalAmount = cartController.totalAmount;

                      print("🛒 Checkout Pressed - Total Amount: \$${cartController.totalAmount}");

                      String? orderId = await cartController.placeOrder(userId, address);

                      if (orderId != null) {
                        String filePath = await PdfInvoice.generateInvoice(
                          orderId: orderId,
                          userAddress: address,
                          items: cartItems.map((product) => {
                            'name': product.name,
                            'quantity': product.quantity,
                            'price': product.price,
                          }).toList(),
                          totalAmount: totalAmount,
                        );

                        cartController.clearCart();
                        Get.snackbar("Success", "Order placed successfully!");

                        // ✅ Show PDF and Add Share Button
                        Get.to(() => PdfViewerScreen(filePath: filePath));
                      } else {
                        Get.snackbar("Error", "Failed to place order. Try again!");
                      }
                    },
                    child: Text("Checkout"),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ✅ Updated PdfViewerScreen with WhatsApp Share Button
class PdfViewerScreen extends StatelessWidget {
  final String filePath;

  PdfViewerScreen({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invoice PDF")),
      body: Column(
        children: [
          Expanded(
            child: PDFView(
              filePath: filePath,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            icon: Icon(Icons.share),
            label: Text("Share on WhatsApp"),
            onPressed: () async {
              await PdfInvoice.shareInvoiceOnWhatsApp(filePath);
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
