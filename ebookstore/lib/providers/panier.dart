import 'package:flutter/material.dart';

class ProduitPanier {
  final String idProd;
  final String title;
  final int qte;
  final double price;

  ProduitPanier({
    required this.idProd,
    required this.title,
    required this.qte,
    required this.price,
  });
}

class Panier with ChangeNotifier {
  Map<String, ProduitPanier> _prodPan = {};

  Map<String, ProduitPanier> get prodPan {
    return {..._prodPan};
  }

  double get totalAmount {
    double total = 0;
    _prodPan.forEach((key, prodPan) {
      total += prodPan.price * prodPan.qte;
    });
    return total;
  }

  int get prodPanCount {
    return _prodPan.length;
  }

  void ajouterProdPan(String idProduit, double price, String title) {
    if (_prodPan.containsKey(idProduit)) {
      _prodPan.update(
        idProduit,
        (existing) => ProduitPanier(
          idProd: existing.idProd,
          title: existing.title,
          qte: existing.qte + 1,
          price: existing.price,
        ),
      );
    } else {
      _prodPan.putIfAbsent(
        idProduit,
        () => ProduitPanier(
            idProd: DateTime.now().toString(),
            title: title,
            qte: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  void suppProdPan(String idProduit) {
    _prodPan.remove(idProduit);
    notifyListeners();
  }

  void supp1Prod(String idProduit) {
    if (!_prodPan.containsKey(idProduit)) {
      return;
    }
    if (_prodPan[idProduit]!.qte > 1) {
      _prodPan.update(
        idProduit,
        (existing) => ProduitPanier(
          idProd: existing.idProd,
          title: existing.title,
          qte: existing.qte - 1,
          price: existing.price,
        ),
      );
    } else {
      _prodPan.remove(idProduit);
    }
    notifyListeners();
  }

  void clear() {
    _prodPan = {};
    notifyListeners();
  }
}
