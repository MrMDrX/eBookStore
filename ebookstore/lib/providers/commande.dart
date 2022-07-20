import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../shared/constants.dart';
import 'auth.dart';
import 'panier.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<ProduitPanier> produits;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.produits,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String? authToken;
  String? userId;

  Orders(this.authToken, this.userId, this._orders);

  void update(Auth auth, List<OrderItem> orders) {
    userId = auth.userId!;
    authToken = auth.token!;
    _orders = orders;
  }

  List<OrderItem> get orders => [..._orders];

  int get ordersCount => _orders.length;

  Future fetchAndSetOrders() async {
    final responseOrd = await http.get(Uri.parse(
        '${Constants.BASE_URL}/${Constants.ORDERS}/$userId.json?auth=$authToken'));

    try {
      final List<OrderItem> loadedOrders = [];
      final extractedData =
          json.decode(responseOrd.body) as Map<String, dynamic>;
      if (extractedData == null) return;

      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            produits: (orderData['produits'] as List<dynamic>)
                .map(
                  (item) => ProduitPanier(
                    idProd: item['id'],
                    price: item['price'],
                    qte: item['quantity'],
                    title: item['title'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addOrders(List<ProduitPanier> prodsPanier, double total) async {
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
          Uri.parse(
              '${Constants.BASE_URL}/${Constants.ORDERS}/$userId.json?auth=$authToken'),
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'produits': prodsPanier
                .map((prodp) => {
                      'id': prodp.idProd,
                      'title': prodp.title,
                      'quantity': prodp.qte,
                      'price': prodp.price,
                    })
                .toList(),
          }));
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            produits: prodsPanier,
            dateTime: timestamp),
      );
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
