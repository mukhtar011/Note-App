import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database_provider.dart';
import 'note_model.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Note')
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Title',
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Your Note'
                  ),
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
           onPressed: () async {
               String title = _titleController.text.trim();
                   String content = _contentController.text.trim();
                 if (title.isNotEmpty && content.isNotEmpty) {
             await DatabaseHelper.instance.insert(Note(
           title: title,
           content: content,
          ));
         Navigator.pop(context);
       } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter title and content.'),
           ));
          }
      },
             label: Text('Save Note'),
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