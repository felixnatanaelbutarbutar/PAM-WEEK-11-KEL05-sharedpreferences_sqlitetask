import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/notes_screen.dart';

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
              Icon(
                Icons.person_add,
                size: 80,
                color: Colors.orange,
              ),
              SizedBox(height: 24),
              Text(
                'Register',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 24),
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
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 30),
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
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Sudah punya akun? Login disini!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
