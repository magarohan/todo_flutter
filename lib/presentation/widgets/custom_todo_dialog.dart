// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo/core/constants/enums.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/data/repositories/todo_repository.dart';

class CustomTodoDialog extends StatefulWidget {
  final TodoModel? todo;
  const CustomTodoDialog({super.key, this.todo});

  @override
  State<CustomTodoDialog> createState() => _CustomTodoDialogState();
}

class _CustomTodoDialogState extends State<CustomTodoDialog> {
  late TextEditingController titleController;
  late TextEditingController descController;
  late Urgency selectedUrgency;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo?.title ?? "");
    descController = TextEditingController(
      text: widget.todo?.description ?? "",
    );
    selectedUrgency = widget.todo?.urgency ?? Urgency.none;
    selectedDate = widget.todo?.dueDate ?? DateTime.now();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 200),
      padding: EdgeInsetsGeometry.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf8e3c6),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, offset: Offset(5, 5)),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.todo == null
                                ? "Add a new TODO"
                                : "Edit TODO",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Title",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: "Enter Title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            child: TextField(
                              controller: descController,
                              maxLines: null,
                              expands: true,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                hintText: "Enter description",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Urgency",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  DropdownButton<Urgency>(
                                    value: selectedUrgency,
                                    dropdownColor: const Color(0xFFf8e3c6),
                                    items: Urgency.values.map((
                                      Urgency urgency,
                                    ) {
                                      return DropdownMenuItem<Urgency>(
                                        value: urgency,
                                        child: Text(urgency.name.toUpperCase()),
                                      );
                                    }).toList(),
                                    onChanged: (Urgency? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          selectedUrgency = newValue;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Due Date",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                            context: context,
                                            initialDate: selectedDate,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2101),
                                          );
                                      if (picked != null &&
                                          picked != selectedDate) {
                                        setState(() {
                                          selectedDate = picked;
                                        });
                                      }
                                    },
                                    child: Text(
                                      "${selectedDate.toLocal()}".split(' ')[0],
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              if (titleController.text.isNotEmpty) {
                                try {
                                  final todo = TodoModel(
                                    id:
                                        widget.todo?.id ??
                                        DateTime.now().millisecondsSinceEpoch
                                            .toString(),
                                    title: titleController.text,
                                    description: descController.text,
                                    dueDate: selectedDate,
                                    updatedAt: DateTime.now(),
                                    urgency: selectedUrgency,
                                    isComplete:
                                        widget.todo?.isComplete ?? false,
                                  );
                                  final navigator = Navigator.of(context);
                                  if (widget.todo == null) {
                                    await TodoRepository.createTodo(todo);
                                  } else {
                                    await TodoRepository.updateTodo(todo);
                                  }
                                  if (!mounted) return;
                                  navigator.pop();
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error: $e")),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Title cannot be empty"),
                                  ),
                                );
                              }
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.todo == null ? "Add" : "Update",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
