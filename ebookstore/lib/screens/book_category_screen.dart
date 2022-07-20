import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop.dart';
import '../widgets/produit_item.dart';

class CategoryBookScreen extends StatelessWidget {
  static const routeName = '/category-books';

  const CategoryBookScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final books = Provider.of<Shop>(context);
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];
    final categoryBooks = books.items.where((book) {
      return book.category.contains(categoryId);
    }).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text(categoryTitle!),
          centerTitle: true,
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: categoryBooks.length,
          itemBuilder: (context, i) => ChangeNotifierProvider.value(
            //create: (context) => produits[i],
            value: categoryBooks[i],
            child: const ProductItem(),
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
        ));
  }
}
