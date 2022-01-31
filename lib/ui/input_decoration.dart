import 'package:flutter/material.dart';

///lo que maneja esta clase es metodos y propiedades estaticas.
///De esta forma no necesito instanciar la clase, solo llamar a los metodos o
///propiedades requeridas. El metodo authInputDecoration lo voy a llamar en la propiedad decoration
///de cada textFromField de mi loginScreen pasandole los argumentos requeridos (labelText y hinttext) y tambien
///puedo pasar el icondata pero es opcional. Por eso tengo que validar que si no se lo paso (es nulo) entonces retorna nulo
class InputDecorations {
  static InputDecoration authInputDecoration(
      {required String labelText,
      required String hintText,
      IconData? prefixIcon}) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple, width: 2)),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null);
  }
}
