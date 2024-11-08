import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            children: [
              ListTile(
                title: Text('Dark Theme'),
                trailing: Switch(
                  value: themeProvider.isDarkTheme,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Account'),
                subtitle: themeProvider.isLoggedIn
                    ? Text('Logged in as ${themeProvider.username}')
                    : Text('Not logged in'),
                trailing: TextButton(
                  onPressed: () {
                    if (themeProvider.isLoggedIn) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Logout'),
                          content: Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                themeProvider.logout();
                                Navigator.pop(context);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Show login screen or other appropriate action
                    }
                  },
                  child: Text(
                    themeProvider.isLoggedIn ? 'Logout' : 'Login',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                title: Text('App Version'),
                subtitle: Text('1.0.0'),
              ),
            ],
          );
        },
      ),
    );
  }
}