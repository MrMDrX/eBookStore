import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'services/connectivity_utils.dart';
import 'package:dcdg/dcdg.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  ConnectivityUtils.getInstance().initialize();
}

/*********************************************
 *               Coded by Medox              *
 *         Telegram : t.me/medoxgeek         *
 *********************************************/