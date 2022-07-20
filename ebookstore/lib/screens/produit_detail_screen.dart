import 'package:ebookstore/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop.dart';
import '../providers/auth.dart';
import '../providers/panier.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/produit-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context)?.settings.arguments as String; // is the id!
    final loadedProduct =
        Provider.of<Shop>(context, listen: false).findById(productId);
    final authData = Provider.of<Auth>(context, listen: false);
    final panier = Provider.of<Panier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 20, bottom: 20),
              //color: Theme.of(context).backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      panier.ajouterProdPan(loadedProduct.id,
                          loadedProduct.price, loadedProduct.title);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            Strings.ADD2CARTMSG,
                            textAlign: TextAlign.center,
                          ),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: Strings.UNDO,
                            onPressed: () {
                              panier.supp1Prod(loadedProduct.id);
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text(Strings.ADD2CART,
                        style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                  IconButton(
                    icon: Icon(
                      loadedProduct.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 35,
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      loadedProduct.toggleFavoriteStatus(
                          authData.token ?? '', authData.userId ?? '');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 20, bottom: 20),
              //color: Theme.of(context).backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Price".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                  Text(
                    '${loadedProduct.price} ${Strings.CURRENCY}'.toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: 'Roboto-Light.ttf',
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 20, bottom: 20),
              //color: Theme.of(context).backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(Strings.DESCRIPTION,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(loadedProduct.description,
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
