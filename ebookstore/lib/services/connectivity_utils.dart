import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class ConnectivityUtils {
  static final ConnectivityUtils _singleton = ConnectivityUtils._internal();

  static ConnectivityUtils getInstance() => _singleton;

  ConnectivityUtils._internal();

  // To Listen to changes in connectivity
  StreamController connectionChangeController = StreamController.broadcast();

  final Connectivity _connectivity = Connectivity();

  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    isConnected();
  }

  Stream get connectionChange => connectionChangeController.stream;

  // A clean up method to close our StreamController
  // Because this is meant to exist through the entire application life cycle this isn't
  // really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    _updateConnectionStatus(result);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<bool> isConnected() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) {
//      return Future.value(null);
//    }

    return _updateConnectionStatus(result);
  }

  Future<bool> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        connectionChangeController.add(true);
        return true;
        break;

      case ConnectivityResult.none:
        connectionChangeController.add(false);
        return false;
        break;
      default:
        connectionChangeController.add(false);
        return false;
        break;
    }
  }
}
