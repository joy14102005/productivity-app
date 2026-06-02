import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/habit_model.dart';
import '../../services/habit_service.dart';
import '../../services/analytics_service.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({Key? key}) : super(key: key);

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final HabitService _service = HabitService();
  final AnalyticsService _analytics = AnalyticsService();
  late Box _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box('focusflow');
  }

  Future<void> _addHabit() async {
    final title = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Habit'),
        content: TextField(controller: title, decoration: const InputDecoration(labelText: 'Habit name')),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final id = DateTime.now().millisecondsSinceEpoch.toString();
              final habit = HabitModel(id: id, userId: 'local', title: title.text);
              await _service.addHabit(habit);
              Navigator.of(ctx).pop();
              setState(() {});
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  Future<void> _completeHabit(HabitModel h) async {
    final now = DateTime.now();
    final map = h.toMap();
    final completions = List<String>.from(map['completions'] ?? [])..add(now.toIso8601String());
    final updated = HabitModel(id: h.id, userId: h.userId, title: h.title, note: h.note, active: h.active, completions: completions);
    await _service.updateHabit(updated);
    await _analytics.logSession({'type': 'habit', 'habitId': h.id, 'time': now.toIso8601String()});
    setState(() {});
  }

  void _deleteHabit(String id) async {
    await _service.deleteHabit(id);
    setState(() {});
  }

  Widget _buildChart(HabitModel h) {
    // simple chart: number of completions per last 7 days
    final now = DateTime.now();
    final counts = List.generate(7, (i) => 0);
    for (var s in h.completions) {
      final d = DateTime.parse(s);
      final diff = now.difference(DateTime(d.year, d.month, d.day)).inDays;
      if (diff >= 0 && diff < 7) {
        counts[6 - diff] += 1;
      }
    }
    return SizedBox(
      height: 80,
      child: BarChart(BarChartData(
        barGroups: List.generate(7, (i) => BarChartGroupData(x: i, barsSpace: 4, barRods: [BarChartRodData(toY: counts[i].toDouble(), width: 8, color: Theme.of(context).colorScheme.primary)])),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keys = _box.keys.where((k) => k.toString().startsWith('habit_')).toList().reversed.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: keys.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No habits yet', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: _addHabit, child: const Text('Add your first habit'))
                  ],
                ),
              )
            : ListView.builder(
                itemCount: keys.length,
                itemBuilder: (ctx, i) {
                  final k = keys[i];
                  final map = Map<String, dynamic>.from(_box.get(k));
                  final h = HabitModel.fromMap(map);
                  return Card(
                    child: ListTile(
                      title: Text(h.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Streak: ${h.currentStreak()}'),
                          const SizedBox(height: 6),
                          _buildChart(h),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'complete') _completeHabit(h);
                          if (v == 'delete') _deleteHabit(h.id);
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(value: 'complete', child: Text('Complete for today')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _addHabit, child: const Icon(Icons.add)),
    );
  }
}
