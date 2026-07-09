import 'package:flutter/material.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/data/repositories/todo_repository.dart';
import 'package:todo/presentation/widgets/custom_todo_dialog.dart';
import 'package:todo/presentation/widgets/custom_todo_tile_widget.dart';
import 'package:todo/presentation/widgets/notebook_background.dart';

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
    final double safeAreaTop = MediaQuery.paddingOf(context).top;

    return NotebookBackground(
      topMargin: safeAreaTop,
      lineSpacing: 60,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Colors.transparent,
            title: const Text(
              "Hello, Rohan",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          floatingActionButton: InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const CustomTodoDialog();
                },
              );
              _refreshTodos();
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.deepOrangeAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.grey, offset: Offset(5, 5)),
                ],
              ),
              child: const Icon(Icons.add, size: 40),
            ),
          ),
          body: FutureBuilder<List<TodoModel>>(
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
                padding: EdgeInsets.zero,
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return CustomTodoTileWidget(
                    todo: todos[index],
                    onChanged: _refreshTodos,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
