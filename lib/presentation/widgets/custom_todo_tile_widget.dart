import 'package:flutter/material.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/data/repositories/todo_repository.dart';
import 'package:todo/presentation/screens/todo_detail_screen.dart';
import 'package:todo/presentation/widgets/custom_todo_dialog.dart';

class CustomTodoTileWidget extends StatefulWidget {
  final TodoModel todo;
  final VoidCallback? onChanged;
  const CustomTodoTileWidget({super.key, required this.todo, this.onChanged});

  @override
  State<CustomTodoTileWidget> createState() => _CustomTodoTileWidgetState();
}

class _CustomTodoTileWidgetState extends State<CustomTodoTileWidget> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.todo.isComplete;
  }

  @override
  void didUpdateWidget(covariant CustomTodoTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.todo.isComplete != widget.todo.isComplete) {
      _isChecked = widget.todo.isComplete;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Transform.rotate(
              angle: 0.1,
              child: Checkbox(
                fillColor: const WidgetStatePropertyAll(Color(0xFFf8e3c6)),
                checkColor: Colors.deepOrangeAccent,
                side: WidgetStateBorderSide.resolveWith(
                  (states) => const BorderSide(color: Colors.black),
                ),
                value: _isChecked,
                onChanged: (bool? value) async {
                  setState(() {
                    _isChecked = value!;
                  });
                  await TodoRepository.updateTodo(
                    widget.todo.copyWith(isComplete: value),
                  );
                  if (widget.onChanged != null) {
                    widget.onChanged!();
                  }
                },
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          TodoDetailScreen(id: widget.todo.id),
                    ),
                  );
                  if (widget.onChanged != null) {
                    widget.onChanged!();
                  }
                },
                child: Text(
                  widget.todo.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    decoration: _isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => CustomTodoDialog(todo: widget.todo),
                );
                if (widget.onChanged != null) {
                  widget.onChanged!();
                }
              },
              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
            ),
            IconButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFFf8e3c6),
                    title: const Text("Delete Todo"),
                    content: const Text(
                      "Are you sure you want to delete this todo?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await TodoRepository.deleteTodo(widget.todo.id);
                  if (widget.onChanged != null) {
                    widget.onChanged!();
                  }
                }
              },
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
