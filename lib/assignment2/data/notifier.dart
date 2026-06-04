import 'dart:async';
import 'package:flutter/material.dart';

// Global navigation key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

ValueNotifier<int> point = ValueNotifier<int>(0);
ValueNotifier<bool> isAutoFail = ValueNotifier<bool>(false);
ValueNotifier<int> progressValue = ValueNotifier<int>(1);
ValueNotifier<int> totalanswer = ValueNotifier<int>(45);
ValueNotifier<int> currentanswer = ValueNotifier<int>(1);
// Timer State
ValueNotifier<int> remainingSeconds = ValueNotifier<int>(2700); // 30 minutes
Timer? quizTimer;

// Helper to format seconds into MM:SS
String formatTime(int seconds) {
  int minutes = seconds ~/ 60;
  int remaining = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${remaining.toString().padLeft(2, '0')}';
}

// Function to reset all quiz data for a new attempt
void resetQuiz() {
  quizTimer?.cancel();
  point.value = 0;
  isAutoFail.value = false;
  remainingSeconds.value = 2700; // Reset to 30 mins
}

// Holds the current screen's score calculator
VoidCallback? onTimeoutScoreCalculator;
