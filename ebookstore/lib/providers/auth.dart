import 'dart:async';
import 'dart:convert';
import '/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../shared/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/theme.dart';

class Auth with ChangeNotifier {
  //final userStream = FirebaseAuth.instance.authStateChanges();
  //final user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  ThemeData theme = lightTheme;
  Key key = UniqueKey();

  bool get isAuth => token != null;

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId => _userId;

  Future<void> _authenticate(
      String email, String password, String authUrl) async {
    final url = Uri.parse(authUrl);
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      _saveUserData(false);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup({required email, required password}) async {
    return _authenticate(email, password, Constants.SIGN_UP_AUTH_URL);
  }

  Future<void> login({required email, required password}) async {
    return _authenticate(email, password, Constants.LOG_IN_AUTH_URL);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final userData = json.decode(prefs.getString('userData') as String)
        as Map<String, Object>;
    final expiryDate = DateTime.parse(userData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData['token'] as String?;
    _userId = userData['userId'] as String?;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    await SharedPreferences.getInstance().then((prefs) async {
      final userData = json.decode(prefs.getString('userData') as String)
          as Map<String, Object>;
      // when login type is login-with-google, sign out that session
      if (userData['loginType'] != null) {
        await googleSignIn.signOut();
      }

      // Clear both db and sharedPreferences data and notify changes
      // final db = DBHelper();
      // db.clear();
      prefs.clear();
    });
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  //save to shared preferences
  void _saveUserData(bool isSocialLogin) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate!.toIso8601String(),
      'loginType': isSocialLogin
    });
    sharedPreferences.setString('userData', userData);
  }

  //Login with Google
  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    assert(!user!.isAnonymous);
    assert(await user?.getIdToken() != null);

    final User? currentUser = _auth.currentUser;
    assert(user!.uid == currentUser!.uid);

    await user!.getIdToken().then((token) {
      _token = token;
    });
    _userId = user.uid;

    notifyListeners();

    _saveUserData(true);

    return true;
  }

  // Another provider can be created to handle theme related code. For this demo
  // defining it here is fine
  void setTheme(value, isDark) {
    theme = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("isDark", isDark).then((val) {});
    });
    notifyListeners();
  }

  ThemeData get getTheme => theme;

  // Check if app theme is light or dark and change app ui accordingly
  Future<ThemeData> checkAppTheme() async {
    final prefs = await SharedPreferences.getInstance();
    ThemeData themeData;
    bool isDark = prefs.getBool('isDark') ?? false;

    if (isDark) {
      themeData = darkTheme;
      setTheme(darkTheme, true);
    } else {
      themeData = lightTheme;
      setTheme(lightTheme, false);
    }

    return themeData;
  }

  /*

  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {}
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> googleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      //handle error
    }
  }
  */
}
