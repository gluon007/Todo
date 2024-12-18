import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/pages/login.dart';
import 'package:todo/service/database.dart';
import 'package:todo/utils/dialog_box.dart';
import 'package:todo/utils/todolist.dart';

class Dashboard extends StatefulWidget {
  final String id;
  const Dashboard({super.key, required this.id});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> todoList = [];
  final _controller = TextEditingController();
  bool isDataLoaded = false;

  @override
  void initState() {
    DatabaseMethods().getdata(widget.id).then((data) {
      if (!mounted) return;
      todoList = data;
      isDataLoaded = true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text(
          'T0 D0 App',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow[500],
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: isDataLoaded
          ? LayoutBuilder(
              builder: (context, constraints) => Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: clampDouble(constraints.maxWidth, 0, 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 100),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "Swipe a task to delete it",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: todoList.length,
                        itemBuilder: (context, index) {
                          return ToDoTile(
                            taskName: todoList[index]['task'],
                            taskCompleted: todoList[index]['isDone'],
                            onChanged: (value) => checkBoxChanged(value, index),
                            deleteFunction: (context) => deleteTask(index),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void checkBoxChanged(bool? value, int index) async {
    todoList[index]['isDone'] = !todoList[index]['isDone'];
    setState(() {});
    await DatabaseMethods().updateTask(todoList, widget.id);
  }

  //  save new task
  void saveNewTask() async {
    todoList.add({'task': _controller.text, 'isDone': false});
    setState(() {
      _controller.clear();
    });
    await DatabaseMethods().updateTask(todoList, widget.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  // // new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // //  delet task
  void deleteTask(int index) async {
    todoList.removeAt(index);
    setState(() {});
    await DatabaseMethods().updateTask(todoList, widget.id);
  }

  void _logout() async {
    await DatabaseMethods().signout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
