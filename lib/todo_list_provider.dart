import 'dart:convert';

import 'package:fltr_mock_sharedpreference/main.dart';
import 'package:fltr_mock_sharedpreference/todo_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoListFutureProvider = FutureProvider<List<TodoModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  var data = ref.read(sharedPreferencesProvider).getString("todoListSp");
  if (data == null) {
    var todoLists = [
      {"id": "0", "description": "Create todo list app", "priority": "high"},
      {"id": "1", "description": "Fix bugs", "priority": "high"},
      {"id": "2", "description": "Change app style", "priority": "medium"}
    ];
    ref
        .watch(sharedPreferencesProvider)
        .setString('todoListSp', json.encode(todoLists));
    return todoModelFromJson(json.encode(todoLists));
  } else {
    return todoModelFromJson(data);
  }
});
