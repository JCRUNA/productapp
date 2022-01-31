// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

///

import 'dart:convert';

class Product {
  Product(
      {required this.available,
      required this.name,
      this.picture,
      required this.price,
      this.id});

  bool available;
  String name;
  String? picture;
  double price;
  String? id;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() =>
      json.encode(toMap()); //nos va a servir para mandar info a nuestro backend

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["Available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "Available": available,
        "name": name,
        "picture": picture,
        "price": price,
      };

  ///creo metodo para copiar mi modelo para romper la referencia
  Product copy() => Product(
      available: this.available,
      name: this.name,
      price: this.price,
      id: this.id,
      picture: this.picture);
}
