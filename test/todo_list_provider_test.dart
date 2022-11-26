import 'dart:convert';

import 'package:fltr_mock_sharedpreference/main.dart';
import 'package:fltr_mock_sharedpreference/todo_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'todo_list_provider_test.mocks.dart';

@GenerateMocks([SharedPreferences])

// a generic Listener class, used to keep track of when a provider notifies its listeners
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  test('get todo list', () async {
    final mockSharedPreferences = MockSharedPreferences();
    var data = '['
        '{"id": "0", "description": "Create todo list app", "priority": "high"},'
        '{"id": "1", "description": "Fix bugs", "priority": "high"},'
        '{"id": "2", "description": "Change app style", "priority": "medium"}'
        ']';
    // Arrange
    when(mockSharedPreferences.getString("todoListSp")).thenReturn(data);

    var container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(mockSharedPreferences)
    ]);

    final listener = Listener<AsyncValue<List<dynamic>>>();

    container.listen<AsyncValue<List<dynamic>>>(
      todoListFutureProvider,
      listener,
      fireImmediately: true,
    );
    // store this into a variable since we'll need it multiple times
    // verify initial value from the build method
    verifyNever(listener(null, const AsyncData<List<dynamic>>([])));

    // Act
    await container.read(todoListFutureProvider.future);

    // Assert

    // verify(listener(null, const AsyncLoading<List<dynamic>>()));
    verifyInOrder([
      listener(null, const AsyncLoading<List<dynamic>>()),
      listener(
        const AsyncLoading<List<dynamic>>(),
        AsyncData<List<dynamic>>(json.decode(data)),
      )
    ]);

    // expect(
    //     const AsyncData<List<dynamic>>([
    //       {
    //         "id": "0",
    //         "description": "Create todo list app",
    //         "priority": "high"
    //       },
    //       {"id": "1", "description": "Fix bugs", "priority": "high"},
    //       {"id": "2", "description": "Change app style", "priority": "medium"}
    //     ]).value.length,
    //     3);
  });
}
