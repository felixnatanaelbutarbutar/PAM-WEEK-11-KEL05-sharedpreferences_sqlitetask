import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note.dart';
import '../helpers/database_helper.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;

  NoteDetailScreen({this.note});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _isEditing = widget.note != null;
  }

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final note = Note(
      id: widget.note?.id,
      title: _titleController.text,
      content: _contentController.text,
      dateTime: DateTime.now(),
    );

    if (_isEditing) {
      await DatabaseHelper.instance.updateNote(note);
    } else {
      await DatabaseHelper.instance.createNote(note);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Note' : 'New Note',
          style: GoogleFonts.dancingScript(
            textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              style: GoogleFonts.dancingScript(
                textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.green[700]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green[400]!),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Content Input
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: GoogleFonts.dancingScript(
                  textStyle: TextStyle(fontSize: 18, color: Colors.black87),
                ),
                decoration: InputDecoration(
                  labelText: 'Content',
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(color: Colors.green[700]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green[700]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green[700]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green[400]!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveNote,
        label: Text(
          _isEditing ? 'Update' : 'Save',
          style: GoogleFonts.dancingScript(
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
        icon: Icon(Icons.save),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
