// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, duplicate_ignore, prefer_const_constructors, unnecessary_new, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

// ignore: unnecessary_new
void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new MaterialApp(title: 'Shopping List', home: new TodoList());
  }
}

// ignore: use_key_in_widget_constructors
class TodoList extends StatefulWidget {
  @override
  // ignore: unnecessary_new
  _TodoListState createState() => new _TodoListState();
}

// ignore: duplicate_ignore
class _TodoListState extends State<TodoList> {
  // ignore: prefer_final_fields
  List<String> _todoList = [];
  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add a task to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter task here"),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              new FlatButton(
                child: new Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              // ignore: deprecated_member_use
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _addTodoItem(String title) {
    setState(() {
      _todoList.add(title);
    });
    _textFieldController.clear();
  }

  List<Widget> _getItems() {
    List<Widget> _todoWidgets = [];
    for (String title in _todoList) {
      _todoWidgets.add(_buildTodoItem(title));
    }
    return _todoWidgets;
  }

  Widget _buildTodoItem(String title) {
    return new ListTile(title: new Text(title));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Shopping List'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(children: _getItems()),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        child: Text(
          'Samarth | Devin | Abhinav \n 102116103|102116079|102116003\n| Kushal | Harsha \n102116097|102116055|\n | Pulkit | Yash\n102116114|102166002',
          textScaleFactor: 1.1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: new Icon(Icons.add)),
    );
  }
}
