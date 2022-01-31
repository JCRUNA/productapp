import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos/providers/product_form_provider.dart';
import 'package:provider/provider.dart';

import 'package:productos/services/product_service.dart';
import 'package:productos/ui/input_decoration.dart';
import 'package:productos/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      ///el ProductFormProvider lo instancia aca ya que solo lo uso en la pantalla product_screen
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductsScreenBody(productService: productService),
    );
  }
}

class _ProductsScreenBody extends StatelessWidget {
  const _ProductsScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  url: productService.selectedProduct.picture,
                ),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 40, color: Colors.white),
                    )),
                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final XFile? pickedFile = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 100);
                        if (pickedFile == null) {
                          print('no selecciono nada');
                          return;
                        }

                        print('Tenemos imagen ${pickedFile.path}');
                        productService.updateSelectedImage(pickedFile.path);
                      },
                      icon: const Icon(Icons.camera_alt_outlined,
                          size: 40, color: Colors.white),
                    ))
              ],
            ),
            const _ProductForm(),
            const SizedBox(
              height: 100,
            ) //coloco esto ya que cuando ingreso texto el teclado aparece y me da mas espacio de scroll
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: productService.isSaving
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.save_outlined),
        onPressed: productService.isSaving
            ? null
            : () async {
                //TO DO: GUARDAR PRODUCTO
                if (!productForm.isValidForm()) return;
                final String? imageUrl = await productService.uploadImage();
                if (imageUrl != null) {
                  productForm.product.picture = imageUrl;
                }
                await productService.saveOrCreateProduct(productForm.product);
              },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
        width: double.infinity,
        child: Form(
            key: productForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: product.name,
                  onChanged: (value) => product.name = value,
                  validator: (value) {
                    if (value == null || value.length < 1)
                      return 'el nombre es obligatorio';
                  },
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Nombre', hintText: 'Nombre del Producto'),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  ///uso una expresion regular para que el usuario ingrese solo valores numericos con maximo 2 decimales al campo precio
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  initialValue: product.price.toString(),
                  onChanged: (value) {
                    ///con try parse intentamos convertir el texto a numero. Si no se puede entonces retorna null.
                    if (double.tryParse(value) == null) {
                      product.price = 0;
                    } else {
                      product.price = double.parse(value);
                    }
                  },
                  keyboardType: TextInputType.number, //teclado numerico
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Precio', hintText: '\$150'),
                ),
                const SizedBox(height: 30),
                SwitchListTile.adaptive(
                  title: const Text('Disponible'),
                  activeColor: Colors.indigo,
                  value: product.available,
                  onChanged: (value) {
                    productForm.updateAvailable(value);
                  },
                ),
                const SizedBox(height: 30),
              ],
            )),
        decoration: _ProductFormBoxDec(),
      ),
    );
  }

  BoxDecoration _ProductFormBoxDec() => BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 10),
            blurRadius: 10)
      ],
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(25),
        bottomLeft: Radius.circular(25),
      ));
}
