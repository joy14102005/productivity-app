import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late Box _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box('focusflow');
  }

  Future<void> _addTask() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                final t = TaskModel(id: id, userId: 'local', title: titleController.text, description: descController.text);
                _box.put('task_$id', t.toMap());
                Navigator.of(ctx).pop();
                setState(() {});
              },
              child: const Text('Add'))
        ],
      ),
    );
  }

  void _deleteTask(String key) {
    _box.delete(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final keys = _box.keys.where((k) => k.toString().startsWith('task_')).toList().reversed.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: keys.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No tasks yet', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: _addTask, child: const Text('Add your first task'))
                  ],
                ),
              )
            : ListView.builder(
                itemCount: keys.length,
                itemBuilder: (ctx, i) {
                  final k = keys[i];
                  final map = Map<String, dynamic>.from(_box.get(k));
                  final t = TaskModel(id: map['id'] ?? k, userId: map['userId'] ?? 'local', title: map['title'] ?? '', description: map['description']);
                  return Card(
                    child: ListTile(
                      title: Text(t.title),
                      subtitle: t.description != null ? Text(t.description!) : null,
                      trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteTask(k)),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
