import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos/providers/login_form_provider.dart';
import 'package:productos/ui/input_decoration.dart';
import 'package:productos/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30),

                    ///uso el provider solo para el loginform
                    MultiProvider(providers: [
                      ChangeNotifierProvider(create: (_) => LoginFormProvider())
                    ], child: const LoginForm())
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text('Crear una nueva cuenta',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

///widget para crear el formulario
class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(

          //Mantener la referencia del ky
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'example@hotmail.com',
                  labelText: 'Correo Electronico',
                  prefixIcon: Icons.alternate_email,
                ),
                onChanged: (value) => loginForm.email =
                    value, //cuando ingreso un mail se lo asigno a mi propiedad email
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El correo ingresado no tiene el formato adecuado';
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true, //oculto cuando escribe la contrasena
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '****',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_open_outlined,
                ),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  if (value != null && value.length <= 6) {
                    ///primero evalua la priemr expresion en caso que no sea nula sigue con value.lenght
                    return 'La contraseña tiene que ser mayor a 5 caracteres';
                  }
                },
              ),
              const SizedBox(height: 20),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.deepPurple,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 20),
                    child: Text(
                      loginForm.isLoading ? 'Ingresando...' : 'Ingresar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  //si esta cargando entonces deshabilito el boton
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          ///saco el foco del teclado cuando presiono el boton
                          FocusScope.of(context).unfocus();

                          if (!loginForm.isValidForm()) return;
                          //si pasa las validaciones del formulario entonces isloading pongo true (aplico el set)
                          loginForm.isLoading = true;
                          //con el future simulo una peticion https esperando 2 segundos
                          await Future.delayed(Duration(seconds: 2));
                          //navego a la pagina homescreen
                          Navigator.pushReplacementNamed(context, 'home');
                        })
            ],
          )),
    );
  }
}
