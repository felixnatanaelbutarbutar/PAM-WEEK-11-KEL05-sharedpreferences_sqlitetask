import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import '../models/note.dart';
import '../providers/theme_provider.dart';
import 'login_page.dart';
import 'settings_screen.dart';
import 'notes_detail_screen.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late Future<List<Note>> _notesFuture;
  bool _isDatabaseConnected = false;

  @override
  void initState() {
    super.initState();
    _checkDatabase();
    _refreshNotes();
  }

  Future<void> _checkDatabase() async {
    _isDatabaseConnected = await DatabaseHelper.instance.isDatabaseConnected();
    if (_isDatabaseConnected) {
      List<String> tables = await DatabaseHelper.instance.getTables();
      print('Available tables: $tables');
    }
    setState(() {});
  }

  void _refreshNotes() {
    setState(() {
      _notesFuture = DatabaseHelper.instance.getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Diary',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          Icon(
            _isDatabaseConnected ? Icons.cloud_done : Icons.cloud_off,
            color: _isDatabaseConnected ? Colors.green : Colors.red,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  themeProvider.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No notes yet. Add your first note!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            padding: EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final note = snapshot.data![index];
              return Dismissible(
                key: Key(note.id.toString()),
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white, size: 28),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await DatabaseHelper.instance.deleteNote(note.id!);
                  _refreshNotes();
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('MMM dd, yyyy - HH:mm').format(note.dateTime),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailScreen(note: note),
                        ),
                      );
                      if (result == true) {
                        _refreshNotes();
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailScreen(),
            ),
          );
          if (result == true) {
            _refreshNotes();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
