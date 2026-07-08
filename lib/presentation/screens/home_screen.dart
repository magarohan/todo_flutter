import 'package:flutter/material.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/data/repositories/todo_repository.dart';
import 'package:todo/presentation/widgets/custom_todo_dialog.dart';
import 'package:todo/presentation/widgets/custom_todo_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<TodoModel>> _todosFuture;

  @override
  void initState() {
    super.initState();
    _todosFuture = TodoRepository.getAllTodos();
  }

  void _refreshTodos() {
    setState(() {
      _todosFuture = TodoRepository.getAllTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background_image.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                "Hello, Rohan",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "All",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: InkWell(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomTodoDialog();
                  },
                );
                _refreshTodos();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  shape: BoxShape.circle,

                  boxShadow: [
                    BoxShadow(color: Colors.grey, offset: Offset(5, 5)),
                  ],
                ),
                child: Icon(Icons.add, size: 40),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<List<TodoModel>>(
                future: _todosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No todos yet"));
                  }

                  final todos = snapshot.data!;
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: CustomTodoTileWidget(todo: todos[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
