import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();

  String email = '';
  String password = '';

  ///esta variable la uso para poder manejar el estado cuando presiono el boton ingresar. Se debe redibujar el boton cambiando el texto
  ///a ingresando o mostrando un circulo de loading.
  bool _isLoading = false;

  ///trabajo con set y getter. Cuando cambia el estado del loading entonces se notifica a los widget que estan escuchando
  bool get isLoading {
    return _isLoading;
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(formKey.currentState?.validate());

    return formKey.currentState?.validate() ??
        false; //si no es nulo entonces llama al metodo validate(). Si es nulo retorna false
  }
}
