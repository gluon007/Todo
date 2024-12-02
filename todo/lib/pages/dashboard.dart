import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/user.dart';
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
  // TEXT CONTROLLER
  MyUser user = MyUser();

  @override
  void initState() {
    user.id = widget.id;
    super.initState();
  }

  final _controller = TextEditingController();
  List<dynamic> todoList = [];

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      todoList[index][1] = !todoList[index][1];
    });
  }

  //  save new task
  void saveNewTask() async {
    todoList.add({_controller.text, false});
    setState(() {
      _controller.clear();
    });
    print("list: $todoList");
    await DatabaseMethods().addNewTask(todoList, user.id!);
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
          onCancel: () => Navigator.of(context).pop,
        );
      },
    );
  }

  // //  delet task
  void deleteTask(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
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
            onPressed: _logout, // Logout action
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: DatabaseMethods().getdata(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (todoList.isEmpty) {
              return const Center(child: Text('No Task!'));
            }
            todoList = snapshot.data!;
            return LayoutBuilder(
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
                            taskName: todoList[index][0],
                            taskCompleted: todoList[index][1],
                            onChanged: (value) => checkBoxChanged(value, index),
                            deleteFunction: (context) => deleteTask(index),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
