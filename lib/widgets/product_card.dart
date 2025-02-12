import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../controllers/cart_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final CartController cartController = Get.find<CartController>();

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(product.image, fit: BoxFit.cover, width: double.infinity),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("\$${product.price.toStringAsFixed(2)}"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                cartController.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${product.name} added to cart")),
                );
              },
              child: Text("Add to Cart"),
            ),
          ),
        ],
      ),
    );
  }
}
