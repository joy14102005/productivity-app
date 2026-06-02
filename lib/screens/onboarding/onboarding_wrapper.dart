import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'onboarding_screen.dart';

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({Key? key}) : super(key: key);

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(onFinish: () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_seen', true);
      final box = Hive.box('focusflow');
      final hasUser = box.get('local_user') != null;
      Navigator.of(context).pushReplacementNamed(hasUser ? '/home' : '/auth');
    });
  }
}
