import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  var cartItems = <int, Product>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
  }

  Future<void> _saveCartToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartJson = cartItems.values.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList('cart', cartJson);
  }

  Future<void> _loadCartFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartJson = prefs.getStringList('cart');
    if (cartJson != null) {
      cartItems.clear();
      for (String item in cartJson) {
        Product product = Product.fromJson(jsonDecode(item));
        cartItems[product.id] = product;
      }
    }
  }

  void addToCart(Product product) {
    if (cartItems.containsKey(product.id)) {
      cartItems[product.id]!.quantity += 1;
    } else {
      cartItems[product.id] = Product(
        id: product.id,
        name: product.name,
        price: product.price,
        image: product.image,
        quantity : 1,
      );
    }
    _saveCartToStorage();
    update();
  }

  void increaseQuantity(int productId) {
    if (cartItems.containsKey(productId)) {
      cartItems[productId] = cartItems[productId]!.copyWith(quantity: cartItems[productId]!.quantity + 1);
      _saveCartToStorage();
      update();  // 🔄 Force UI refresh
    }
  }


  void decreaseQuantity(int productId) {
    if (cartItems.containsKey(productId)) {
      if (cartItems[productId]!.quantity > 1) {
        cartItems[productId] = cartItems[productId]!.copyWith(quantity: cartItems[productId]!.quantity - 1);
      } else {
        cartItems.remove(productId);
      }
      _saveCartToStorage();
      update();  // 🔄 Force UI refresh
    }
  }


  void removeFromCart(int productId) {
    cartItems.remove(productId);
    _saveCartToStorage();
    update();
  }

  double get totalAmount {
    return cartItems.values.fold(0, (sum, item) => sum + (item.price * item.quantity ));
  }

  void clearCart() {
    cartItems.clear();
    _saveCartToStorage();
    update();
  }

  Future<String?> placeOrder(int userId, String address) async {
    String apiUrl = "http://10.0.2.2/ecommerce_api/save_order.php";
    List<Map<String, dynamic>> items = cartItems.values.map((product) => {
      "id": product.id,
      "name": product.name,
      "price": product.price,
      "quantity": product.quantity ,
      "image": product.image,
    }).toList();

    Map<String, dynamic> orderData = {
      "user_id": userId.toString(),
      "address": address,
      "items": items,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == "success") {
          String orderId = responseData['order_id'].toString();
          clearCart();
          return orderId;
        }
      }
      return null;
    } catch (error) {
      print("Order Error: $error");
      return null;
    }
  }
}
