import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;
  bool _isLoggedIn = false;
  String _username = '';
  String _password = ''; // Menambahkan password
  SharedPreferences? _prefs;

  bool get isDarkTheme => _isDarkTheme;
  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;

  ThemeProvider() {
    _loadFromPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _loadFromPrefs() async {
    await _initPrefs();
    _isDarkTheme = _prefs?.getBool('darkTheme') ?? false;
    _isLoggedIn = _prefs?.getBool('isLoggedIn') ?? false;
    _username = _prefs?.getString('username') ?? '';
    _password = _prefs?.getString('password') ?? ''; // Menambahkan password
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    await _initPrefs();
    _isDarkTheme = value;
    _prefs?.setBool('darkTheme', value);
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    await _initPrefs();
    // Logika login yang memeriksa username dan password di SharedPreferences
    if (username == _username && password == _password) {
      _isLoggedIn = true;
      _prefs?.setBool('isLoggedIn', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    await _initPrefs();
    // Simpan username dan password ke SharedPreferences
    if (username.isNotEmpty && password.isNotEmpty) {
      _username = username;
      _password = password;
      _prefs?.setString('username', username);
      _prefs?.setString('password', password);
      _prefs?.setBool('isLoggedIn', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _initPrefs();
    _isLoggedIn = false;
    _username = '';
    _password = '';
    _prefs?.setBool('isLoggedIn', false);
    _prefs?.remove('username');
    _prefs?.remove('password');
    notifyListeners();
  }

  ThemeData get themeData => _isDarkTheme ? ThemeData.dark() : ThemeData.light();
}
