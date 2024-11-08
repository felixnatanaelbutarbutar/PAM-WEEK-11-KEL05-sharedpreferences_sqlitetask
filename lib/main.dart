import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharedpreferences_sqlitetask/screens/login_page.dart';
import 'providers/theme_provider.dart';
import 'screens/notes_screen.dart';
import 'screens/register_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Diary App',
          theme: themeProvider.themeData,
          initialRoute: themeProvider.isLoggedIn ? '/notes' : '/login',
          routes: {
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/notes': (context) => NotesScreen(),
          },
        );
      },
    );
  }
}