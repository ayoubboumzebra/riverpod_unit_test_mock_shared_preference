import 'package:fltr_mock_sharedpreference/todo_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoListFuture = ref.watch(todoListFutureProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo list app'),
      ),
      body: todoListFuture.when(
        data: (todoLists) {
          return ListView.builder(
            itemCount: todoLists.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(todoLists[index].description);
            },
          );
        },
        error: (err, _) => const Center(
          child: Text('Error fetching data'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
