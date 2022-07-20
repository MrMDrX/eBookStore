import 'package:ebookstore/shared/strings.dart';
import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'produits_overview_screen.dart';
import 'profile_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getBottomBar(),
      body: getPage(),
    );
  }

  Widget getBottomBar() {
    return BottomNavigationBar(
        elevation: 0,
        selectedFontSize: 16,
        currentIndex: activeTab,
        onTap: (index) => setState(() => activeTab = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 20,
            ),
            label: Strings.HOME,
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.apps,
              size: 20,
            ),
            label: Strings.CATEGORIES,
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              size: 20,
            ),
            label: Strings.CART,
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.payment,
              size: 20,
            ),
            label: Strings.ORDERS,
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 20,
            ),
            label: Strings.PROFILE,
            backgroundColor: Color.fromRGBO(39, 105, 171, 1),
          ),
        ]);
  }

  Widget getPage() {
    return IndexedStack(
      index: activeTab,
      children: const [
        ProduitsOverviewScreen(),
        CategoriesScreen(),
        CartScreen(),
        OrdersScreen(),
        ProfileScreen(),
      ],
    );
  }
}
