import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/notes_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
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

    final userIndex = existingUsernames.indexOf(username);

    if (userIndex != -1 && existingPasswords[userIndex] == password) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NotesScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Teks selamat datang
              Text(
                'Welcome to My Diary',
                style: TextStyle(
                  fontFamily:
                      'DancingScript', // Nama font yang sudah ditambahkan
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(221, 0, 0, 0),
                ),
              ),

              // Ikon buku
              Image.asset(
                'assets/images/book.jpg', // Path ke gambar book.jpg
                width: 120, // Sesuaikan lebar gambar
                height: 120, // Sesuaikan tinggi gambar
              ),
              // Teks login
              Text(
                'Login',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 24),

              // Kolom teks username
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

              // Kolom teks password
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

              // Pesan error
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 30),

              // Tombol login
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
                onPressed: _login,
                child: Text('Login', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 20),

              // Tombol register
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child: Text('Belum punya akun? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
