import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diary.db');
    print('Database initialized successfully');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, filePath);
  print('Database path: $path');

  return await openDatabase(
    path,
    version: 2, // Increment this version when schema changes are made
    onCreate: _createDB,
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        print('Upgrading database from version $oldVersion to $newVersion');
        // Example of adding a new column to a table
        await db.execute('ALTER TABLE notes ADD COLUMN new_column TEXT');
        // Add more upgrade logic as needed
      }
    },
  );
}

  Future _createDB(Database db, int version) async {
    print('Creating new database...');
    // Create notes table
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        dateTime TEXT NOT NULL
      )
    ''');

    // Create users table for registration and login
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    print('Database tables created successfully');
  }

  // Method to create a new note
  Future<Note> createNote(Note note) async {
    final db = await instance.database;
    print('Creating new note: ${note.title}');
    final id = await db.insert('notes', note.toMap());
    print('Note created with ID: $id');
    return note.copyWith(id: id);
  }

  // Method to get all notes
  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;
    print('Fetching all notes...');
    final result = await db.query('notes', orderBy: 'dateTime DESC');
    print('Found ${result.length} notes');
    return result.map((json) => Note.fromMap(json)).toList();
  }

  // Method to update a note
  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    print('Updating note with ID: ${note.id}');
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Method to delete a note
  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    print('Deleting note with ID: $id');
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Method for user registration with username check
  Future<bool> registerUser(String username, String password) async {
    final db = await instance.database;
    try {
      // Check if username already exists
      final result = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (result.isNotEmpty) {
        print('Username already exists');
        return false;
      }

      // Insert a new user into the 'users' table
      await db.insert('users', {'username': username, 'password': password});
      print('User $username registered successfully');
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Method for user login
  Future<bool> loginUser(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      print('User $username logged in successfully');
      return true;
    }
    print('Invalid credentials');
    return false;
  }

  // Method to check database connection
  Future<bool> isDatabaseConnected() async {
    try {
      final db = await instance.database;
      await db.query('notes', limit: 1);
      print('Database connection test successful');
      return true;
    } catch (e) {
      print('Database connection test failed: $e');
      return false;
    }
  }

  // Method to list all tables in the database
  Future<List<String>> getTables() async {
    final db = await instance.database;
    final tables = await db.query(
      'sqlite_master',
      where: 'type = ?',
      whereArgs: ['table'],
    );
    print('Available tables: ${tables.map((e) => e['name']).toList()}');
    return tables.map((e) => e['name'].toString()).toList();
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
    print('Database connection closed');
  }
}


  













