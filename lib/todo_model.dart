// To parse this JSON data, do
//
//     final todoModel = todoModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

List<TodoModel> todoModelFromJson(String str) =>
    List<TodoModel>.from(json.decode(str).map((x) => TodoModel.fromJson(x)));

String todoModelToJson(List<TodoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TodoModel extends Equatable {
  const TodoModel({
    required this.id,
    required this.description,
    required this.priority,
  });

  final String id;
  final String description;
  final String priority;

  @override
  List<Object> get props => [id, description, priority];

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json["id"],
        description: json["description"],
        priority: json["priority"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "priority": priority,
      };
}
