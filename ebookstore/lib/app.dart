import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'providers/commande.dart';
import '../providers/panier.dart';
import 'screens/book_category_screen.dart';
import 'screens/home_screen.dart';
import '../screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/shop.dart';
import 'screens/auth_screen.dart';
import 'screens/produit_detail_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
//import 'theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Shop>(
          create: (context) => Shop('', '', []),
          update: (context, auth, prevProduits) => Shop(
            auth.token ?? '',
            auth.userId ?? '',
            prevProduits == null ? [] : prevProduits.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Panier(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', '', []),
          update: (context, auth, prevOrd) => Orders(
            auth.token ?? '',
            auth.userId ?? '',
            prevOrd == null ? [] : prevOrd.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          key: auth.key,
          title: 'eBook Store',
          theme: auth.theme,
          home: auth.isAuth
              ? const HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authRes) =>
                      authRes.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CategoryBookScreen.routeName: (ctx) => const CategoryBookScreen(),
          },
          onUnknownRoute: (stngs) {
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          },
        ),
      ),
    );
  }
}

/*********************************************
 *               Coded by Medox              *
 *         Telegram : t.me/medoxgeek         *
 *********************************************/