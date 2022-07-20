import 'package:ebookstore/providers/panier.dart';
import 'package:ebookstore/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/produit.dart';
import '../screens/produit_detail_screen.dart';
//import 'package:google_fonts/google_fonts.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final produit = Provider.of<Produit>(context);
    final panier = Provider.of<Panier>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        //header: const Text('price'),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            icon: Icon(
                produit.isFavorite ? Icons.favorite : Icons.favorite_border),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              produit.toggleFavoriteStatus(
                  authData.token ?? '', authData.userId ?? '');
            },
          ),
          title: Text(produit.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              )
              // GoogleFonts.montserrat(
              //   textStyle: const TextStyle(
              //     fontSize: 10.0,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              panier.ajouterProdPan(produit.id, produit.price, produit.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  content: const Text(
                    Strings.ADD2CARTMSG,
                    //style: TextStyle(color: Theme.of(context).primaryColor),
                    //textAlign: TextAlign.center,
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: Strings.UNDO,
                    onPressed: () {
                      panier.supp1Prod(produit.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        child: GestureDetector(
          onDoubleTap: () {
            produit.toggleFavoriteStatus(
                authData.token ?? '', authData.userId ?? '');
          },
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              //ProductDetailScreen.routeName,
              arguments: produit.id,
            );
          },
          child: Image.network(
            produit.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
