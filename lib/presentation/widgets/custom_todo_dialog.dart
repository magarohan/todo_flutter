import 'package:flutter/material.dart';
import 'package:todo/core/constants/enums.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/data/repositories/todo_repository.dart';

class CustomTodoDialog extends StatefulWidget {
  const CustomTodoDialog({super.key});

  @override
  State<CustomTodoDialog> createState() => _CustomTodoDialogState();
}

class _CustomTodoDialogState extends State<CustomTodoDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  Urgency selectedUrgency = Urgency.none;
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFf8e3c6),
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
                    const Text(
                      "Add a new TODO",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Title"),
                    TextField(
                      controller: titleController,
                      style: null,
                      decoration: InputDecoration(
                        hintText: "Enter Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Description"),
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
                            const Text("Urgency"),
                            DropdownButton<Urgency>(
                              value: selectedUrgency,
                              items: Urgency.values.map((Urgency urgency) {
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
                            const Text("Due Date"),
                            TextButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null && picked != selectedDate) {
                                  setState(() {
                                    selectedDate = picked;
                                  });
                                }
                              },
                              child: Text(
                                "${selectedDate.toLocal()}".split(' ')[0],
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        if (titleController.text.isNotEmpty) {
                          final todo = TodoModel(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            title: titleController.text,
                            description: descController.text,
                            dueDate: selectedDate,
                            updatedAt: DateTime.now(),
                            urgency: selectedUrgency,
                          );
                          final navigator = Navigator.of(context);
                          await TodoRepository.createTodo(todo);
                          if (!mounted) return;
                          navigator.pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Title cannot be empty"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12),
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(color: Colors.grey, offset: Offset(5, 5)),
                          ],
                        ),
                        child: const Text(
                          "Add",
                          style: TextStyle(
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
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
