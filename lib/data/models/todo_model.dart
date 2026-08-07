import '../../core/constants/enums.dart';

class TodoModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime updatedAt;
  final Urgency urgency;
  final Category category;
  final bool isComplete;

  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.updatedAt,
    required this.urgency,
    required this.category,
    this.isComplete = false,
  });

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? updatedAt,
    Urgency? urgency,
    Category? category,
    bool? isComplete,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      updatedAt: updatedAt ?? this.updatedAt,
      urgency: urgency ?? this.urgency,
      category: category ?? this.category,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] ?? '',
      dueDate: DateTime.parse(map['dueDate'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      urgency: Urgency.values.firstWhere(
        (e) => e.name == map['urgency'],
        orElse: () => Urgency.none,
      ),
      category: Category.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => Category.none,
      ),
      isComplete: map['isComplete'] == 1 || map['isComplete'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'urgency': urgency.name,
      'category': category.name,
      'isComplete': isComplete == true ? 1 : 0,
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      TodoModel.fromMap(json);
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'TodoModel(id: $id, title: $title, description: $description, dueDate: $dueDate, updatedAt: $updatedAt, urgency: $urgency, category: $category, isComplete: $isComplete)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TodoModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.dueDate == dueDate &&
        other.updatedAt == updatedAt &&
        other.urgency == urgency &&
        other.category == category &&
        other.isComplete == isComplete;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        dueDate.hashCode ^
        updatedAt.hashCode ^
        urgency.hashCode ^
        category.hashCode ^
        isComplete.hashCode;
  }
}
