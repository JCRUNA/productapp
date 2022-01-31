import 'package:flutter/material.dart';
import 'package:productos/models/models.dart';
import 'package:productos/screens/screens.dart';
import 'package:productos/services/product_service.dart';
import 'package:productos/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(
        context); //EN LA TERMINAL VEMOS LOS DATOS OBTENIDOS DE LA PETICION
    if (productsService.isLoading) {
      return LoadingScreen();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Productos'),
      ),
      body: ListView.builder(
          itemCount: productsService.products.length,
          //crea los widget de manera perezosa. Util para muchos elementos
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  productsService.selectedProduct = productsService
                      .products[index]
                      .copy(); //hago copia del producto seleccionado para trabajar con el mismo y no con el original
                  Navigator.pushNamed(context, 'product');
                },
                child: ProductCard(
                  product: productsService.products[index],
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ///debo crear aca instancia de productservices sino da error por leer algo nulo
          productsService.selectedProduct =
              Product(available: false, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
