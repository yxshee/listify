// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, duplicate_ignore, prefer_const_constructors, unnecessary_new, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors

import 'package:flutter/material.dart';

// Main application entry point
void main() => runApp(new App());

// Data model for a single to-do item
class TodoItem {
  String title;
  bool isDone;

  TodoItem({required this.title, this.isDone = false});
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Shopping List',
      // Define a simple theme for the app
      theme: ThemeData(
        primarySwatch: Colors.orange, // Main theme color
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.orange,
          accentColor: Colors.redAccent, // Accent color for FAB, etc.
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange, // AppBar background
          foregroundColor: Colors.white, // AppBar text/icon color
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.redAccent, // FAB background
          foregroundColor: Colors.white,    // FAB icon color
        ),
        // Define text button style to replace deprecated FlatButton
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.orange, // Text color for buttons
          ),
        ),
        // Define elevated button style (if needed elsewhere)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
        // Use Material3 design components
        useMaterial3: true,
      ),
      home: new TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => new _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // List to store TodoItem objects
  List<TodoItem> _todoList = [];
  // Controller for the text field in the dialog
  TextEditingController _textFieldController = TextEditingController();
  // Focus node to automatically focus the text field
  FocusNode _textFieldFocusNode = FocusNode();

  // Displays a dialog to add a new task
  Future<void> _displayDialog(BuildContext context) async {
    // Ensure the text field is focused when the dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_textFieldFocusNode);
    });

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add an item to your list'),
          content: TextField(
            controller: _textFieldController,
            focusNode: _textFieldFocusNode, // Assign the focus node
            decoration: InputDecoration(
              hintText: "Enter item here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            autofocus: true, // Automatically focus the text field
            onSubmitted: (_) { // Allow submitting with the enter key
              _submitAddItem(context);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: new Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
                _textFieldController.clear(); // Clear controller on cancel
              },
            ),
            ElevatedButton( // Use ElevatedButton for primary action
              child: new Text('ADD'),
              onPressed: () {
                _submitAddItem(context);
              },
            ),
          ],
          shape: RoundedRectangleBorder( // Add rounded corners to the dialog
            borderRadius: BorderRadius.circular(15.0)
          ),
        );
      },
    );
  }

  // Handles submission of a new item from the dialog
  void _submitAddItem(BuildContext context) {
    if (_textFieldController.text.isNotEmpty) {
      _addTodoItem(_textFieldController.text);
      Navigator.of(context).pop(); // Close dialog only if item is added
    } else {
      // Optional: Show a small message if the field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item name cannot be empty!'),
          backgroundColor: Colors.red.shade400,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Adds a new item to the to-do list
  void _addTodoItem(String title) {
    setState(() {
      _todoList.add(TodoItem(title: title));
    });
    _textFieldController.clear(); // Clear the text field after adding
  }

  // Toggles the 'isDone' status of a to-do item
  void _toggleTodoItem(int index) {
    setState(() {
      _todoList[index].isDone = !_todoList[index].isDone;
    });
  }

  // Removes a to-do item from the list
  void _removeTodoItem(int index, TodoItem item) {
    setState(() {
      _todoList.removeAt(index);
    });
    // Show a SnackBar with an Undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} removed'),
        backgroundColor: Colors.grey.shade700,
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.orangeAccent,
          onPressed: () {
            _undoRemove(index, item);
          },
        ),
      ),
    );
  }

  // Re-inserts a removed item (Undo functionality)
  void _undoRemove(int index, TodoItem item) {
    setState(() {
      _todoList.insert(index, item);
    });
  }


  // Builds a single to-do item widget
  Widget _buildTodoItemWidget(TodoItem item, int index) {
    return Dismissible(
      key: Key(item.title + index.toString()), // Unique key for Dismissible
      direction: DismissDirection.endToStart, // Swipe from right to left
      onDismissed: (direction) {
        _removeTodoItem(index, item);
      },
      background: Container(
        color: Colors.red.shade400,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete_sweep, color: Colors.white),
      ),
      child: Card(
        elevation: 3.0, // Add a slight shadow to the card
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: Checkbox(
            value: item.isDone,
            onChanged: (bool? value) {
              _toggleTodoItem(index);
            },
            activeColor: Colors.orange,
          ),
          title: Text(
            item.title,
            style: TextStyle(
              decoration: item.isDone ? TextDecoration.lineThrough : null,
              color: item.isDone ? Colors.grey.shade600 : Colors.black87,
              fontStyle: item.isDone ? FontStyle.italic : FontStyle.normal,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.shade300),
            onPressed: () {
              // Confirmation dialog before deleting
              _showDeleteConfirmationDialog(index, item);
            },
            tooltip: 'Delete Item',
          ),
        ),
      ),
    );
  }

  // Shows a confirmation dialog before deleting an item via the button
  Future<void> _showDeleteConfirmationDialog(int index, TodoItem item) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // User can dismiss by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete "${item.title}"?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
              child: Text('DELETE'),
              onPressed: () {
                _removeTodoItem(index, item);
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('My Shopping List'),
        elevation: 4.0, // Add shadow to app bar
      ),
      // Display list or an empty state message
      body: _todoList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey.shade400),
                  SizedBox(height: 20),
                  Text(
                    'Your shopping list is empty!',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tap the "+" button to add items.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _todoList.length,
              padding: EdgeInsets.symmetric(vertical: 8.0), // Add some padding to the list
              itemBuilder: (context, index) {
                final item = _todoList[index];
                return _buildTodoItemWidget(item, index);
              },
            ),
      // Bottom app bar with styled text
      bottomNavigationBar: BottomAppBar(
        color: Colors.red.shade50, // A lighter, less intrusive color
        padding: EdgeInsets.all(8.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700,
              height: 1.3, // Line height
            ),
            children: const <TextSpan>[
              TextSpan(text: 'Samarth | Devin | Abhinav\n', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '102116103 | 102116079 | 102116003\n'),
              TextSpan(text: 'Kushal | Harsha\n', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '102116097 | 102116055\n'),
              TextSpan(text: 'Pulkit | Yash\n', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '102116114 | 102166002'),
            ],
          ),
        ),
      ),
      // Floating action button to add new items
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Add Item',
        child: new Icon(Icons.add),
        shape: CircleBorder(), // Make FAB perfectly circular
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Center FAB
    );
  }

  // Dispose controllers and focus nodes when the widget is removed from the tree
  @override
  void dispose() {
    _textFieldController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }
}

