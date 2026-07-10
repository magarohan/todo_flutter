import 'package:flutter/material.dart';
import 'package:todo/core/constants/enums.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/data/repositories/todo_repository.dart';
import 'package:todo/presentation/widgets/notebook_background.dart';

class TodoDetailScreen extends StatefulWidget {
  final String id;
  const TodoDetailScreen({super.key, required this.id});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late Future<TodoModel?> _todoFuture;

  @override
  void initState() {
    super.initState();
    _todoFuture = TodoRepository.getTodoById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    const double lineSpacing = 32.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    const double appBarHeight = 64.0;
    const Color notebookColor = Color(0xFFf8e3c6);

    return FutureBuilder<TodoModel?>(
      future: _todoFuture,
      builder: (context, snapshot) {
        final todo = snapshot.data;

        if (todo == null) {
          return Scaffold(
            backgroundColor: notebookColor,
            appBar: AppBar(
              title: const Text('Not Found'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: const Center(child: Text('Todo not found')),
          );
        }

        return Scaffold(
          backgroundColor: notebookColor,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(appBarHeight),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              title: Text(
                todo.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  height: lineSpacing / 20,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: NotebookBackground(
              lineSpacing: lineSpacing,
              topMargin: statusBarHeight,
              baseColor: notebookColor,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                padding: EdgeInsets.only(
                  top: statusBarHeight + appBarHeight,
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            todo.title,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  height: lineSpacing / 24,
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Urgency: ${todo.urgency.name.toUpperCase()}',
                          style: TextStyle(
                            color: _getUrgencyColor(todo.urgency),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: lineSpacing / 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: lineSpacing,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Due: ${todo.dueDate.toString().split(' ')[0]}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              height: lineSpacing / 14,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: todo.isComplete == true
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.orange.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              todo.isComplete == true ? 'Completed' : 'Pending',
                              style: TextStyle(
                                color: todo.isComplete == true
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: lineSpacing),
                    Text(
                      todo.description,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        height: lineSpacing / 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getUrgencyColor(Urgency urgency) {
    switch (urgency) {
      case Urgency.high:
        return Colors.red;
      case Urgency.medium:
        return Colors.orange;
      case Urgency.low:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
