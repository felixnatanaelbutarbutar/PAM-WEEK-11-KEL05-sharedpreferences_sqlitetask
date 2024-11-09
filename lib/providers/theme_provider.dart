import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;
  bool _isLoggedIn = false;
  String _username = '';
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
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    await _initPrefs();
    // Logika validasi username dan password
    _isLoggedIn = true;
    _username = username;
    _prefs?.setBool('isLoggedIn', true);
    _prefs?.setString('username', username);
    notifyListeners();
  }

  Future<void> logout() async {
    await _initPrefs();
    _isLoggedIn = false;
    _username = '';
    _prefs?.setBool('isLoggedIn', false);
    _prefs?.remove('username');
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    await _initPrefs();
    _isDarkTheme = value;
    _prefs?.setBool('darkTheme', value);
    notifyListeners();
  }

  ThemeData get themeData => _isDarkTheme ? ThemeData.dark() : ThemeData.light();
}
