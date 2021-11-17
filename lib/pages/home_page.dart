import 'package:flutter/material.dart';
import 'package:todo_apps/models/todo_model.dart';
import 'package:todo_apps/widgets/todo_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoModel> todos = [];
  TextEditingController todoController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0a500),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Text(
                "Todo List",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 30,
              ),
              // Expanded(child: Container()),


              Expanded(
                child: ReorderableListView.builder(
                    itemCount: todos.length,
                    onReorder: (oldIndex, newIndex){

                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final TodoModel item = todos.removeAt(oldIndex);
                        todos.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      return _listItem(index);
                    }),
              ),

              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  bottom: 50,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: todoController,
                          decoration: InputDecoration.collapsed(
                              hintText: "Add todo..."),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (todoController.text.isNotEmpty) {
                            setState(() {
                              todos.add(TodoModel(
                                  title: todoController.text,
                                  isDone: false,
                                  key: ValueKey(todos.length)));
                              todoController.text = "";
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please enter a todo task..."),
                            ));
                          }
                        },
                        child: Icon(
                          Icons.add,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _listItem(index) => Dismissible(
        key: Key(todos[index].title),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            // Delete
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("This to do task has been deleted"),
            ));
            setState(() {
              todos.removeAt(index);
            });
          } else if (direction == DismissDirection.startToEnd) {
            // Complete
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("This to do task has been Completed"),
            ));
            setState(() {
              todos.removeAt(index);
            });
          }
        },
        child: TodoItem(
          title: todos[index].title,
        ),
      );
}
