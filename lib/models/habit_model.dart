class HabitModel {
  final String id;
  final String userId;
  final String title;
  final String? note;
  final bool active;
  final List<String> completions; // ISO dates of completion

  HabitModel({required this.id, required this.userId, required this.title, this.note, this.active = true, List<String>? completions}) : completions = completions ?? [];

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      note: map['note'],
      active: map['active'] ?? true,
      completions: map['completions'] != null ? List<String>.from(map['completions']) : [],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'title': title,
        'note': note,
        'active': active,
        'completions': completions,
      };

  int currentStreak() {
    if (completions.isEmpty) return 0;
    // completions are ISO strings, sort descending
    final dates = completions.map((s) => DateTime.parse(s)).toList()..sort((a, b) => b.compareTo(a));
    var streak = 0;
    var cursor = DateTime(dates.first.year, dates.first.month, dates.first.day);
    for (var d in dates) {
      final day = DateTime(d.year, d.month, d.day);
      if (day.isAtSameMomentAs(cursor)) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      } else if (day.isBefore(cursor)) {
        // if there's a gap, stop counting
        break;
      }
    }
    return streak;
  }
}
