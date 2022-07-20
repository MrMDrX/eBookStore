import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ebookstore/providers/produit.dart';

import '../services/db_helper.dart';
import '../shared/constants.dart';

class Shop with ChangeNotifier {
  List<Produit> _items = [];

  final _db = DBHelper();

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(Uri.parse(
          '${Constants.BASE_URL}/${Constants.PRODUCTS}.json?auth=$authToken'));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final favoriteResponse = await http.get(Uri.parse(
          '${Constants.BASE_URL}/${Constants.USER_FAVORITES}.json?auth=$authToken'));
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Produit> fetchedProducts = [];
      extractedData.forEach((prodId, prodData) {
        fetchedProducts.add(Produit(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          category: prodData['category'].toString().split(','),
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));

        _db.insert(Constants.USER_PRODUCTS_TABLE, {
          'product_id': prodId,
          'product_name': prodData['title'],
          'product_description': prodData['description'],
          'product_image': prodData['imageUrl'],
          'product_price': double.parse(prodData['price'].toString()),
          'product_favorite': favoriteData == null
              ? 0
              : favoriteData[prodId] == null
                  ? 0
                  : favoriteData[prodId]
                      ? 1
                      : 0,
          'product_category': prodData['category'],
        });
      });
      _items = fetchedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
    return;
  }

  Future fetchOfflineProducts() async {
    // _isLoading = true;
    try {
      final data = await _db.getData(Constants.USER_PRODUCTS_TABLE);

      //print(data);
      _items = data
          .map((prd) => Produit(
                id: prd['product_id'],
                title: prd['product_name'],
                description: prd['product_description'],
                imageUrl: prd['product_image'],
                price: prd['product_price'],
                category: prd['product_category'].toString().split(','),
                isFavorite: int.parse(prd['product_favotite'].toString()) == 1
                    ? true
                    : false,
              ))
          .toList();
      // _isLoading = false;
      notifyListeners();

      return;
    } catch (error) {
      // _isLoading = false;
      rethrow;
    }
  }

  final String authToken;
  final String userId;
  Shop(this.authToken, this.userId, this._items);

  List<Produit> get items {
    return [..._items];
  }

  List<Produit> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Produit findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct() {
    //_items.add();
    notifyListeners();
  }
}


 /*
List<Produit> _items = Produit(
      id: '1092297375',
      title: 'Learn Google Flutter Fast',
      price: 19.99,
      description: 'Learn Google Flutter by example. Over 65 example mini-apps',
      category: 'Programming',
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/41EVkahZTgL._SX398_BO1,204,203,200_.jpg',
    ),
    Produit(
      id: '1788996089',
      title: 'Flutter for Beginners',
      price: 34.99,
      description:
          'Flutter for Beginners: An introductory guide to building cross-platform mobile applications with Flutter and Dart 2',
      category: 'Programming',
      imageUrl: 'https://m.media-amazon.com/images/I/51dikt2obTL._SX260_.jpg',
    ),
    Produit(
      id: '1119612586',
      title: 'Flutter For Dummies',
      price: 17.99,
      description:
          'Flutter for Dummies is your friendly, ground-up route to creating multi-platform apps',
      category: 'Programming',
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/51HYZKo9i-L._SX397_BO1,204,203,200_.jpg',
    ),
    Produit(
      id: '1484251806',
      title: 'Beginning App Development with Flutter',
      price: 11.99,
      description:
          'Create iOS and Android apps with Flutter using just one codebase. This book breaks down complex concepts and tasks into easily digestible segments with examples, pictures, and hands-on labs with starters and solutions',
      category: 'Programming',
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/417aMCUCo3L._SX342_SY445_QL70_FMwebp_.jpg',
    ),
    Produit(
      id: '1092297375',
      title: 'Learn Google Flutter Fast',
      price: 19.99,
      description: 'Learn Google Flutter by example. Over 65 example mini-apps',
      category: 'Programming',
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/41EVkahZTgL._SX398_BO1,204,203,200_.jpg',
    ),
    Produit(
      id: '1788996089',
      title: 'Flutter for Beginners',
      price: 34.99,
      description:
          'Flutter for Beginners: An introductory guide to building cross-platform mobile applications with Flutter and Dart 2',
      category: 'Programming',
      imageUrl: 'https://m.media-amazon.com/images/I/51dikt2obTL._SX260_.jpg',
    ),
    Produit(
      id: '1119612586',
      title: 'Flutter For Dummies',
      price: 17.99,
      description:
          'Flutter for Dummies is your friendly, ground-up route to creating multi-platform apps',
      category: 'Programming',
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/51HYZKo9i-L._SX397_BO1,204,203,200_.jpg',
    ),
    Produit(
      id: '1484251806',
      title: 'Beginning App Development with Flutter',
      price: 11.99,
      description:
          'Create iOS and Android apps with Flutter using just one codebase. This book breaks down complex concepts and tasks into easily digestible segments with examples, pictures, and hands-on labs with starters and solutions',
      category: 'Programming',
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/417aMCUCo3L._SX342_SY445_QL70_FMwebp_.jpg',
    ),
  ];
  */