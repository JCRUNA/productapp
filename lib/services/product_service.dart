///se encarga de hacer las peticiones http

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productos/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'flutter-productapp-7f5e4-default-rtdb.firebaseio.com'; //lo saco de postman
  final List<Product> products =
      []; //lista de productos. Product es la clase definida en product.dart obtenida del json
  bool isLoading = true;
  bool isSaving = false; //para guardar los cambios
  late Product
      selectedProduct; //lo uso para cargar la info del producto seleccionado
  File? imageFile;
  ProductsService() {
    //apenas instanciamos ProductsServise llama al metodo loadproduct que realiza la peticion http
    this.loadProduct();
  }

  Future<List<Product>> loadProduct() async {
    this.isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get(url); //la resp es un string

    final Map<String, dynamic> productsMap = json
        .decode(resp.body); //con decode convertimos el string a formato mapa
    //iteamos en cada elemento del mapa
    //products Map retorna un mapa con cada id del producto
    //print de productMap
    // {ABC123: {Available: true, name: PS5 Controller, picture: https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgYkqNhFcMQ8MrNFZ0O5u_i7-EFI7zV9rek7m_AdaKVYfpPn_EGQkpSQAIaENzkWEt54U&usqp=CAU, price: 75.99},
    // DEF789: {Available: true, name: Microfono Genius, price: 99.99}, XYZ456: {Available: false, name: HDD Google, picture: https://cdn.hobbyconsolas.com/sites/navi.axelspringer.es/public/styles/hc_940x529/public/media/image/2018/05/claves-comprar-disco-duro.jpg?itok=dOkKZqTk, price: 125.25}}
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value); //creo instancia del producto
      tempProduct.id = key; //para el primer producto seria ABC
      products
          .add(tempProduct); //agrego a la lista vacia la info de cada producto
      // print(products[0].name);//OBTENGO EL NOMBRE DEL PRIMER PRODUCTO
    });

    //cuando termino de hacer la peticion y rellenar la lista entonces loading paso a false
    this.isLoading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      //entones es necesario crear porque no tiene id
      await createProduct(product);
    } else {
      //necesito actualizar
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');

    ///uso el metodo put para reemplazar valores en mi base de datos
    final resp = await http.put(url,
        body: product
            .toJson()); //el body es un string json. hacemos uso del metodo toJson creado por quictype
    final decodedData = resp.body;
    // print(decodedData);
    /// Cuando actualizo el producto en el formulario de mi productScreen tengo que asegurarme que despues de grabar los cambios
    /// cuando vuelvo para a tras a mi homeScreen donde se encuentra la lista de productos, el producto aparezca actualizado.
    /// Para hacer eso debo recorrer mi lista de products y comprar el id de cada producto con el id del producto que acabo de modificar.
    /// Para hacer eso uso el metodo indexwhere que retorna el indice index. Luego asigno el product actualizado a la lista de productos en en index encotnrado.
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');

    ///uso el metodo post para crear valores en mi base de datos de firebase
    final resp = await http.post(url,
        body: product
            .toJson()); //el body es un string json. hacemos uso del metodo toJson creado por quictype
    final decodedData = json.decode(resp.body);

    ///si imprimimo en pantalla el decoded data print(decodedData) vemos que retorna el id del producto
    ///entonces ahora se lo asigno a mi product.id y agrego mi producto a la lista de products
    product.id = decodedData['name'];
    products.add(product);

    return product.id!;
  }

  void updateSelectedImage(String path) {
    selectedProduct.picture = path;
    imageFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (imageFile == null) return null;
    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dm68jw6ll/image/upload?upload_preset=bcjezv1s');

    final imageUploadRequest =
        http.MultipartRequest('POST', url); //creo peticion

    final file = await http.MultipartFile.fromPath(
        'file', imageFile!.path); //defino path al file

    imageUploadRequest.files.add(file); //adjunto path

    final streamResponse = await imageUploadRequest.send(); //envio la peticion

    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    imageFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
