import 'package:flutter/material.dart';
import 'package:productos/models/models.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        // color: Colors.red,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(
              url: product.picture,
            ),
            _ProductDetail(
              product: product,
            ),
            Positioned(
                top: 0, right: 0, child: _PriceTag(price: product.price)),
            //TO DO: MOSTRAR DE MANERA CONDICIONAL. SI ESTA DISPONIBLE SE MUESTRA SINO NO.

            if (!product
                .available) //si no esta disponible entonces que muestre el widget de no disponible
              Positioned(top: 0, left: 0, child: _notAvailable()),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black, blurRadius: 10, offset: Offset(0, 10))
          ]);
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({
    Key? key,
    this.url,
  }) : super(key: key);

  final String? url; //url de la imagen que puedo o no venir
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: url ==
                null //si no hay url de imagen entonces muestro imagen predeterminada
            ? const Image(
                image: AssetImage('assets/no-image.jpg'),
                fit: BoxFit.cover,
              )
            : FadeInImage(
                placeholder: const AssetImage('assets/loading.gif'),
                image: NetworkImage(url!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _ProductDetail extends StatelessWidget {
  const _ProductDetail({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildboxdecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(product.id ?? 'sin id',
                style: const TextStyle(color: Colors.white, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildboxdecoration() => const BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({
    Key? key,
    required this.price,
  }) : super(key: key);

  final double price;
  @override
  Widget build(BuildContext context) {
    return Container(
      //usamos el fittebox para que el texto se adapta su tamano de acuerdo a la cantidad de caracteres
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('\$ ' + '$price',
              style: const TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
    );
  }
}

class _notAvailable extends StatelessWidget {
  const _notAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No disponible',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
    );
  }
}
