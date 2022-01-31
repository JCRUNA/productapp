import 'package:flutter/material.dart';
import 'package:productos/models/models.dart';

///maneja el estado del formulario
class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product product;

  ///metodo para manejar y cambiar el switch de available
  updateAvailable(bool valor) {
    this.product.available = valor;
    notifyListeners();
  }

  ProductFormProvider(this.product);

  bool isValidForm() {
    print(product.name);
    print(product.price);
    print(product.available);
    return formKey.currentState?.validate() ?? false;
  }
}
