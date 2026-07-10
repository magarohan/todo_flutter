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
  final GlobalKey _fabKey = GlobalKey();

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

  Future<void> _openTodoDialog() async {
    final RenderBox? fabBox =
        _fabKey.currentContext?.findRenderObject() as RenderBox?;
    final Size screenSize = MediaQuery.of(context).size;

    Alignment fabAlignment = Alignment.bottomRight;
    if (fabBox != null) {
      final Offset fabCenter = fabBox.localToGlobal(
        fabBox.size.center(Offset.zero),
      );
      fabAlignment = Alignment(
        (fabCenter.dx / screenSize.width) * 2 - 1,
        (fabCenter.dy / screenSize.height) * 2 - 1,
      );
    }

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const CustomTodoDialog();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
            reverseCurve: Curves.easeInCubic,
          ),
          alignment: fabAlignment,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );

    _refreshTodos();
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
            onTap: _openTodoDialog,
            child: Container(
              key: _fabKey,
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
