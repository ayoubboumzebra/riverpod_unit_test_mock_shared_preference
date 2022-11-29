import 'dart:convert';

import 'package:fltr_mock_sharedpreference/main.dart';
import 'package:fltr_mock_sharedpreference/todo_list_provider.dart';
import 'package:fltr_mock_sharedpreference/todo_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

// a generic Listener class, used to keep track of when a provider notifies its listeners
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  
  setUpAll(() {
    registerFallbackValue(const AsyncData<List<TodoModel>>([]));
  });
  
  test('get todo list', () async {
    final mockSharedPreferences = MockSharedPreferences();
    
    List<TodoModel> data = [
      const TodoModel(
          id: "0", description: "Create todo list app", priority: "high"),
      const TodoModel(id: "1", description: "Fix bugs", priority: "high"),
    ];

    // Arrange
    when(() => mockSharedPreferences.getString("todoListSp"))
        .thenReturn(json.encode(data));

    var container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(mockSharedPreferences)
    ]);

    final listener = Listener<AsyncValue<List<TodoModel>>>();

    container.listen<AsyncValue<List<TodoModel>>>(
      todoListFutureProvider,
      listener,
      fireImmediately: true,
    );

    verifyNever(() => listener(null, const AsyncData<List<TodoModel>>([])));

    // Act
    var todoListProvider = await container.read(todoListFutureProvider.future);

    // Assert
    verifyInOrder([
      () => listener(null, const AsyncLoading<List<TodoModel>>()),
      () => listener(const AsyncLoading<List<TodoModel>>(),
          any(that: isA<AsyncData<List<TodoModel>>>()))
    ]);

    expect(todoListProvider.length, 2);
  });
}
