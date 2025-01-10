import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TodoApppp());
}

class TodoApppp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '_ToDo_',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _addTask(String title, String description) {
    if (title.isNotEmpty) {
      setState(() {
        _tasks.add({
          'title': title,
          'description': description,
          'isCompleted': false,
          'isSaved': false, // To track if the task is saved in Firebase
        });
      });
      _titleController.clear();
      _descriptionController.clear();
    }
  }

  Future<void> _saveTaskToFirebase(int index) async {
    final task = _tasks[index];
    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'title': task['title'],
        'description': task['description'],
        'isCompleted': task['isCompleted'],
      });
      setState(() {
        _tasks[index]['isSaved'] = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task saved to Firebase!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save task: $e')),
      );
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted'];
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(hintText: 'Enter the task'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(hintText: 'description'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addTask(_titleController.text, _descriptionController.text);
                Navigator.of(context).pop();
              },
              child: Text('Add Task'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('_ToDo_'),
      ),
      body: _tasks.isEmpty
          ? Center(
        child: Text(
          'No tasks added !!!!!',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_tasks[index]['title']),
            background: Container(color: Colors.red),
            onDismissed: (direction) {
              _deleteTask(index);
            },
            child: ListTile(
              title: Text(
                _tasks[index]['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: _tasks[index]['isCompleted']
                      ? TextDecoration.none
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                _tasks[index]['description'] ?? '',
                style: TextStyle(
                  decoration: _tasks[index]['isCompleted']
                      ? TextDecoration.none
                      : TextDecoration.none,
                ),
              ),
              leading: Checkbox(
                value: _tasks[index]['isCompleted'],
                onChanged: (value) {
                  _toggleTaskCompletion(index);
                },
              ),
              trailing: ElevatedButton(
                onPressed: _tasks[index]['isSaved']
                    ? null
                    : () => _saveTaskToFirebase(index),
                child: Text('Save'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
