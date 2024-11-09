import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/notes_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final existingUsernames = prefs.getStringList('usernames') ?? [];
    final existingPasswords = prefs.getStringList('passwords') ?? [];

    if (existingUsernames.contains(username)) {
      setState(() {
        _errorMessage = 'Username already exists';
      });
      return;
    }

    // Add the new username and password to the lists and save them
    existingUsernames.add(username);
    existingPasswords.add(password);

    await prefs.setStringList('usernames', existingUsernames);
    await prefs.setStringList('passwords', existingPasswords);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', username);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NotesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                'My Diary',
                style: GoogleFonts.dancingScript(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(221, 0, 0, 0),
                ),
              ),

              // Icon
              Image.asset(
                'assets/images/diary.png',
                width: 120,
                height: 120,
              ),
              SizedBox(height: 24),

              // Username input
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Password input
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Error message
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 30),

              // Register button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
                onPressed: _register,
                child: Text('Register', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 20),

              // Login button
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  'Already have an account? Login here',
                  style: TextStyle(fontSize: 16, color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
