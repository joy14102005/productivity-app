import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const OnboardingScreen({Key? key, required this.onFinish}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Focus like a pro',
      'subtitle': 'AI-powered planner, smart timers, and habit tracking to build focus.'
    },
    {
      'title': 'Plan your study',
      'subtitle': 'Create subjects, set priorities and deadlines, get smart recommendations.'
    },
    {
      'title': 'Track progress',
      'subtitle': 'Daily analytics, streaks, and performance charts to stay motivated.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final p = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Icon(Icons.auto_graph, size: 96, color: Theme.of(context).colorScheme.primary),
                              ),
                              const SizedBox(height: 24),
                              Text(p['title']!, style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: 12),
                              Text(p['subtitle']!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Row(
                children: [
                  TextButton(onPressed: () => widget.onFinish(), child: const Text('Skip')),
                  const Spacer(),
                  Row(
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: _page == i ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _page == i ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_page == _pages.length - 1) {
                        widget.onFinish();
                      } else {
                        _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                      }
                    },
                    child: const Text('Next'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
