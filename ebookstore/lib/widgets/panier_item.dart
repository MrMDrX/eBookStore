import 'package:ebookstore/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/panier.dart';

class PanierItem extends StatelessWidget {
  final String id;
  final String idProduit;
  final String title;
  final int qte;
  final double price;

  const PanierItem({
    super.key,
    required this.id,
    required this.idProduit,
    required this.title,
    required this.qte,
    required this.price,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(Strings.DELETE_TITLE),
            content: const Text(Strings.DELETE_MESSAGE),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text(Strings.NO),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text(Strings.YES),
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Panier>(context, listen: false).suppProdPan(idProduit);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: Chip(
              label: Text('$price'),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: Text(title),
            subtitle: Text('${price * qte} ${Strings.CURRENCY}'),
            trailing: Text('$qte x'),
          ),
        ),
      ),
    );
  }
}
