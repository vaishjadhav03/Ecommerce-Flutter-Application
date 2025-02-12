class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final int stock; // Available stock
  int quantity; // User-added quantity (mutable)

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.stock = 1, // Default stock
    this.quantity = 1, // Default cart quantity
  });

  /// Creates a copy of the product with optional changes
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      name: name,
      price: price,
      image: image,
      stock: stock,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Converts the Product object to JSON format
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "image": image,
      "stock": stock, // Updated key
      "quantity": quantity,
    };
  }

  /// Converts JSON to a Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] is String)
          ? double.tryParse(json['price']) ?? 0.0
          : (json['price'] ?? 0.0),
      image: json['image'] ?? '',
      stock: json.containsKey('stock') ? int.tryParse(json['stock'].toString()) ?? 1 : 1,
      quantity: json.containsKey('quantity') ? int.tryParse(json['quantity'].toString()) ?? 1 : 1,
    );
  }
}
