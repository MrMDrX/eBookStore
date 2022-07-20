import 'package:ebookstore/shared/strings.dart';
import '../providers/commande.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/commande.dart' show Orders;
import '../widgets/order_item.dart' as item;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  //static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    //print('building orders');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.ORDERS_SCREEN),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return const Center(
                child: Text(Strings.ERROR),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, ordersData, _) => ordersData.ordersCount == 0
                    ? const Center(
                        child: Text(Strings.NORDERS),
                      )
                    : ListView.builder(
                        itemBuilder: (context, i) =>
                            item.OrderItem(ordersData.orders[i]),
                        itemCount: ordersData.ordersCount,
                      ),
              );
            }
          }
        },
      ),
    );
  }
}
