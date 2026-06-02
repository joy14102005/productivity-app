import 'package:flutter/material.dart';
import 'dashboard_widget.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const DashboardWidget(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ActionCard(title: 'Planner', icon: Icons.calendar_month, route: '/planner'),
                  _ActionCard(title: 'Tasks', icon: Icons.task, route: '/tasks'),
                  _ActionCard(title: 'Focus Timer', icon: Icons.timer, route: '/focus'),
                  _ActionCard(title: 'Habits', icon: Icons.auto_awesome, route: '/habits'),
                  _ActionCard(title: 'Analytics', icon: Icons.bar_chart, route: '/analytics'),
                  _ActionCard(title: 'Profile', icon: Icons.person, route: '/profile'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  const _ActionCard({required this.title, required this.icon, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // map lightweight routes to actual screens
        if (route == '/tasks') Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NavigatorPlaceholder(title: 'Tasks')));
        else if (route == '/planner') Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NavigatorPlaceholder(title: 'Planner')));
        else if (route == '/focus') Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NavigatorPlaceholder(title: 'Focus Timer')));
        else if (route == '/habits') Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NavigatorPlaceholder(title: 'Habits')));
        else if (route == '/analytics') Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NavigatorPlaceholder(title: 'Analytics')));
        else if (route == '/profile') Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NavigatorPlaceholder(title: 'Profile')));
      },
      child: Container(
        width: 140,
        height: 120,
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
            const Spacer(),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class NavigatorPlaceholder extends StatelessWidget {
  final String title;
  const NavigatorPlaceholder({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text('$title - placeholder')));
  }
}
