import 'package:ebookstore/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/commande.dart';
import '../providers/panier.dart';
import '../widgets/panier_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final panier = Provider.of<Panier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.CART_SCREEN),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    Strings.TOTAL,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                        '${panier.totalAmount.toStringAsFixed(2)} ${Strings.CURRENCY}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleLarge!
                              .color,
                        )),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(panier: panier)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: panier.prodPanCount,
                itemBuilder: (context, i) => PanierItem(
                    id: panier.prodPan.values.toList()[i].idProd,
                    title: panier.prodPan.values.toList()[i].title,
                    price: panier.prodPan.values.toList()[i].price,
                    qte: panier.prodPan.values.toList()[i].qte,
                    idProduit: panier.prodPan.keys.toList()[i])),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.panier,
  }) : super(key: key);

  final Panier panier;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.panier.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrders(
                  widget.panier.prodPan.values.toList(),
                  widget.panier.totalAmount);
              setState(() {
                _isLoading = false;
              });
              widget.panier.clear();
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text(Strings.ORDERNOW),
    );
  }
}
