import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'timer/timer_screen.dart';
import 'tasks/tasks_screen.dart';
import 'analytics/analytics_screen.dart';
import 'profile/profile_screen.dart';
import '../widgets/app_bottom_nav.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _index = 0;
  static const List<Widget> _pages = [
    HomeScreen(),
    TimerScreen(),
    TasksScreen(),
    AnalyticsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: AppBottomNav(currentIndex: _index, onTap: (i) => setState(() => _index = i)),
    );
  }
}
