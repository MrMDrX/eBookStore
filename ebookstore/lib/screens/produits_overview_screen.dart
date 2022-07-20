import 'package:ebookstore/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop.dart';
import '../services/connectivity_utils.dart';
import '../widgets/produits_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProduitsOverviewScreen extends StatefulWidget {
  const ProduitsOverviewScreen({super.key});

  @override
  State<ProduitsOverviewScreen> createState() => _ProduitsOverviewScreenState();
}

class _ProduitsOverviewScreenState extends State<ProduitsOverviewScreen> {
  final connectivity = ConnectivityUtils.getInstance();
  bool _connectionStatus = true;

  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  Future<void> _refreshProduits(BuildContext context) async {
    if (_connectionStatus) {
      await Provider.of<Shop>(context, listen: false).fetchAndSetProducts();
    } else {
      await Provider.of<Shop>(context, listen: false).fetchOfflineProducts();
    }
  }

/*
  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Produits>(context).fetchAndSetProducts();
    });
    //Provider.of<Produits>(context).fetchAndSetProducts();
    super.initState();
  }
*/

  @override
  void initState() {
    super.initState();
    initConnectivity();
    listenToConnectivityChanges();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Shop>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.APP_NAME),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.Favorites,
                child: Text(Strings.ONLYFAVS),
              ),
              const PopupMenuItem(
                value: FilterOptions.All,
                child: Text(Strings.SHOWALL),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshProduits(context),
              child: ProduitsGrid(_showOnlyFavorites)),
    );
  }

  void initConnectivity() async {
    final connectionState = await connectivity.isConnected();

    setState(() {
      _connectionStatus = connectionState;
    });
  }

  void listenToConnectivityChanges() {
    connectivity.connectionChange.listen((hasConnection) {
      if (mounted) {
        setState(() {
          _connectionStatus = hasConnection;
        });
      }
    });
  }
}
