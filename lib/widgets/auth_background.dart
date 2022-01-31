import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _PurpleBox(),
          const IconCabecera(),
          child,
        ],
      ),
    );
  }
}

class IconCabecera extends StatelessWidget {
  const IconCabecera({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(Icons.person_pin, color: Colors.white, size: 100),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  const _PurpleBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.40,
      decoration: _boxDecoration(),
      child: Stack(
        children: const [
          Positioned(child: _Burbuja(), top: 90, left: 30),
          Positioned(child: _Burbuja(), top: -40, left: -30),
          Positioned(child: _Burbuja(), top: -50, left: -20),
          Positioned(child: _Burbuja(), bottom: -50, left: 10),
          Positioned(child: _Burbuja(), bottom: 120, left: 20),
        ],
      ),
    );
  }

  ///extraigo metodo asi queda mas limpio. Le pasamos un gradiente lineal
  BoxDecoration _boxDecoration() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1)
      ]));
}

class _Burbuja extends StatelessWidget {
  const _Burbuja({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}
