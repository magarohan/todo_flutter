import 'package:flutter/material.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/presentation/screens/todo_detail_screen.dart';
import 'package:todo/data/repositories/todo_repository.dart';

class CustomTodoTileWidget extends StatefulWidget {
  final TodoModel todo;
  final bool isChecked;
  const CustomTodoTileWidget({
    super.key,
    required this.todo,
    this.isChecked = false,
  });

  @override
  State<CustomTodoTileWidget> createState() => _CustomTodoTileWidgetState();
}

class _CustomTodoTileWidgetState extends State<CustomTodoTileWidget> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  void didUpdateWidget(covariant CustomTodoTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      _isChecked = widget.isChecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.rotate(
          angle: 0.1,
          child: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              fillColor: const WidgetStatePropertyAll(Color(0xFFf8e3c6)),
              checkColor: Colors.deepOrangeAccent,
              side: const BorderSide(color: Colors.black),
              value: _isChecked,
              onChanged: (bool? value) async {
                setState(() {
                  _isChecked = value!;
                });
                await TodoRepository.updateTodo(
                  widget.todo.copyWith(isComplete: value),
                );
              },
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TodoDetailScreen(id: widget.todo.id),
              ),
            );
          },
          child: Text(
            widget.todo.title,
            style: TextStyle(
              decoration: _isChecked
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
