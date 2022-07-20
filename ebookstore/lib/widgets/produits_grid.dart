import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop.dart';
import 'produit_item.dart';

class ProduitsGrid extends StatelessWidget {
  final bool showFavs;
  const ProduitsGrid(this.showFavs, {super.key});

  @override
  Widget build(BuildContext context) {
    final produitsData = Provider.of<Shop>(context);
    final produits = showFavs ? produitsData.favoriteItems : produitsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: produits.length,
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        //create: (context) => produits[i],
        value: produits[i],
        child: const ProductItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
