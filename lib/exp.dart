// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:undo/undo.dart';

// class UndoScreen extends StatefulWidget {
//   @override
//   _UndoScreenState createState() => _UndoScreenState();
// }

// class _UndoScreenState extends State<UndoScreen> {
//   late SimpleStack _controller;

//   @override
//   void initState() {
//     _controller = SimpleStack<int>(
//       5,
//       onUpdate: (val) {
//         if (mounted) {
//           setState(() {
//             print('New Value -> $val');
//           });
//         }
//       },
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final count = _controller.state;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Undo/Redo Example'),
//       ),
//       body: Center(
//         child: Text('Count: $count'),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           children: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: !_controller.canUndo
//                   ? null
//                   : () {
//                       if (mounted) {
//                         setState(() {
//                           _controller.undo();
//                         });
//                       }
//                     },
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward),
//               onPressed: !_controller.canRedo
//                   ? null
//                   : () {
//                       if (mounted) {
//                         setState(() {
//                           _controller.redo();
//                         });
//                       }
//                     },
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//       floatingActionButton: FloatingActionButton(
//         heroTag: const ValueKey('add_button'),
//         child: const Icon(Icons.add),
//         onPressed: () {
//           _controller.modify(count + 1);
//         },
//       ),
//     );
//   }
// }

// final userProvider = StateProvider(((ref) => 0));

// class AltPage extends ConsumerWidget {
//   const AltPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(userProvider);
//     ref.listen(userProvider, (previous, next) {
//       // Text(previous.toString());
//       print(previous);
//     });

//     // final user2 = ref.listen(userProvider, (previous, next) {
//     //   // Text(previous.toString());
//     //   print(next);
//     // });
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           Row(
//             children: <Widget>[
//               IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () {
//                     // user1;
//                   }),
//               IconButton(
//                   icon: const Icon(Icons.arrow_forward),
//                   onPressed: () {
//                     // user2;
//                   }),
//             ],
//           ),

//           // cancelImg()
//         ],
//       ),
//       body: Center(
//         child: Text(
//           user.toString(),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           ref.read(userProvider.notifier).state++;
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class States extends StateNotifier {
//   States(super.state);

//   void increment() => (state + 1);

//   void decrement() => (state - 1);
// }

// final users = StateNotifierProvider(((ref) => States(2)));

// class AltPage1 extends ConsumerWidget {
//   const AltPage1({Key? key}) : super(key: key);

//   void onSubmit(WidgetRef ref) {
//     ref.read(users.notifier).increment();
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final use = ref.watch(users) as int;

//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             Text(
//               use.toString(),
//             ),
//             ElevatedButton(
//               onPressed: (() {
//                 onSubmit(ref);
//               }),
//               child: const Text('next'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// typedef Update<S> = S Function(S state);

// class Store<S> extends ChangeNotifier {
//   Store(S initialState) : _state = initialState;
//   S _state;

//   S get state => _state;

//   void apply(Update<S> update) {
//     _state = update(_state);
//     notifyListeners();
//   }
// }

// class Todo {
//   Todo(this.id, this.text, this.completed);
//   final int id;
//   final String text;
//   final bool completed;

//   Todo complete() => Todo(id, text, true);
// }

// typedef TodoList = List<Todo>;

// extension on TodoList {
//   TodoList update(int id, Update<Todo> update) {
//     return [...map((todo) => todo.id == id ? update(todo) : todo)];
//   }
// }

// Update<TodoList> add(int id, String text) {
//   return (state) => state + [Todo(id, text, false)];
// }

// Update<TodoList> remove(int id) {
//   return (state) => [...state.where((todo) => todo.id != id)];
// }

// Update<TodoList> complete(int id) {
//   return (state) => state.update(id, (todo) => todo.complete());
// }

// abstract class Command {
//   void execute();
//   void undo();
//   void redo() => execute();
// }

// class AddCommand extends Command {
//   AddCommand(this.list, this.todo);
//   final TodoList list;
//   final Todo todo;

//   @override
//   void execute() => list.add(todo);

//   @override
//   void undo() => list.remove(todo);
// }

// class UndoStack {
//   final _commands = <Command>[];
//   var _index = 0;

//   bool get canUndo => _index > 0;
//   bool get canRedo => _index < _commands.length - 1;

//   void execute(Command command) {
//     _commands.length = _index++;
//     _commands.add(command..execute());
//   }

//   void undo() {
//     if (!canUndo) return;
//     _commands[--_index].undo();
//   }

//   void redo() {
//     if (!canRedo) return;
//     _commands[_index++].redo();
//   }
// }

// class ToDos extends StatefulWidget {
//   const ToDos({Key? key}) : super(key: key);

//   @override
//   State<ToDos> createState() => _ToDosState();
// }

// class _ToDosState extends State<ToDos> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           Row(
//             children: <Widget>[
//               IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () {
//                     // user1;
//                     UndoStack().undo();
//                   }),
//               IconButton(
//                   icon: const Icon(Icons.arrow_forward),
//                   onPressed: () {
//                     // user2;
//                     UndoStack().redo();
//                   }),
//             ],
//           ),
//         ],
//       ),
//       // body: UndoStack().execute(command),
//     );
//   }
// }