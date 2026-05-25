import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project2/assignment2/model/general_model.dart';
import 'package:project2/assignment2/data/general_data.dart';
import 'package:project2/assignment2/screen/result_screen.dart';
import 'package:project2/assignment2/screen/sign_screen.dart';
import 'package:project2/assignment2/data/notifier.dart';

class GeneralQuizScreen extends StatefulWidget {
  const GeneralQuizScreen({super.key});

  @override
  State<GeneralQuizScreen> createState() => _GeneralQuizScreenState();
}

class _GeneralQuizScreenState extends State<GeneralQuizScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  int?
  _selectedAnswerIndex; // NEW: tracks the chosen option (1, 2, or 3) for the active question
  final List<Question> _questions = QuizData.generalquestions;
  final Map<int, int> _selectedAnswersHistory = {};
  int finalScore = 0;
  bool _isScoreCalculated = false;
  // 1. Create a fresh list to hold the randomized sequence
  final List<Question> _randomizedQuestions = [];

  @override
  void initState() {
    super.initState();
    _startTimer();
    // 2. Copy the original list so you don't mess up your raw data file
    _randomizedQuestions.addAll(QuizData.generalquestions);
    // 3. Shuffle it! This randomizes the order completely.
    _randomizedQuestions.shuffle();
    // Register THIS screen's score calculator with the global timer
    onTimeoutScoreCalculator = _calculateFinalScore;
  }

  void _startTimer() {
    quizTimer?.cancel(); // Reset if exists
    remainingSeconds.value = 2700;
    quizTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    onTimeoutScoreCalculator?.call(); // calls whichever screen is active
    // Navigate to Result Screen automatically when time is up
    if (mounted) {
      _calculateFinalScore();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ResultScreen()),
        (route) => false,
      );
    }
  }

  void _makeanswers() {
    if (_selectedAnswerIndex != null) {
      _selectedAnswersHistory[_currentIndex] = _selectedAnswerIndex!;
    }
  }

  void _calculateFinalScore() {
    if (_isScoreCalculated) {
      return;
    }
    _isScoreCalculated = true;
    int tempscore = 0;

    // Loop through every answered question in your history map
    _selectedAnswersHistory.forEach((questionIndex, chosenAnswerIndex) {
      // Look up the actual question object using the index key
      final actualQuestion = _questions[questionIndex];

      // Check if the user's choice matches the correct answer key
      if (chosenAnswerIndex == actualQuestion.correctAnswer) {
        tempscore++; // Correct! Add a point.
      }
    });
    finalScore = tempscore;
    point.value = point.value + finalScore;
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        // FIXED: Checks if next question already has a saved answer
        _selectedAnswerIndex = _selectedAnswersHistory[_currentIndex + 1];
      });
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        // FIXED: Checks if next question already has a saved answer
        _selectedAnswerIndex = _selectedAnswersHistory[_currentIndex - 1];
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: ValueListenableBuilder<int>(
                valueListenable: remainingSeconds,
                builder: (context, seconds, child) {
                  bool isLowTime =
                      seconds < 60; // Turn red if less than 1 minute
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isLowTime
                          ? Colors.red.withValues(alpha: 0.1)
                          : Colors.deepPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 18,
                          color: isLowTime ? Colors.red : Colors.deepPurple,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatTime(seconds),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isLowTime ? Colors.red : Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        title: Column(
          children: [
            const Text(
              'Traffic Quiz Challenge',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'សំណួរទី ${_currentIndex + 1} / ${_questions.length} ',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'KhmerFont',
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: (_currentIndex + 1) / _questions.length,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation(Colors.deepPurple),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _randomizedQuestions.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final currentQuestion = _randomizedQuestions[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6A5AE0), Color(0xFF8B7BFF)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            currentQuestion.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'KhmerFont',
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.quiz_rounded,
                                      color: Colors.deepPurple,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  const Text(
                                    'Question',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 22),

                              Text(
                                currentQuestion.question,
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.7,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  fontFamily: 'KhmerFont',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        _buildAnswerOption(currentQuestion.answer1, 0),

                        _buildAnswerOption(currentQuestion.answer2, 1),

                        _buildAnswerOption(currentQuestion.answer3, 2),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _currentIndex > 0 ? _previousQuestion() : null;
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: _currentIndex > 0
                            ? Colors.deepPurple
                            : Colors.grey.shade400,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'ថយក្រោយ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _currentIndex > 0
                            ? Colors.deepPurple
                            : Colors.grey,
                        fontFamily: 'KhmerFont',
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedAnswerIndex == null) {
                        const snackBar = SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Select an answer to move forward.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(16),
                          elevation: 10,
                          duration: Duration(seconds: 2),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                      if (_selectedAnswerIndex != null) {
                        _makeanswers();

                        if (_currentIndex == _questions.length - 1) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.12,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),

                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // ICON
                                      Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.orange.withValues(
                                            alpha: 0.12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.warning_amber_rounded,
                                          size: 50,
                                          color: Colors.orange,
                                        ),
                                      ),

                                      const SizedBox(height: 24),

                                      // TITLE
                                      const Text(
                                        "បញ្ជាក់",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'KhmerFont',
                                          color: Colors.black87,
                                        ),
                                      ),

                                      const SizedBox(height: 16),

                                      // CONTENT
                                      const Text(
                                        "ប្រសិនបើចុចទៅខាងមុខ អ្នកមិនអាចត្រឡប់ក្រោយបានទេ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          height: 1.6,
                                          color: Colors.black54,
                                          fontFamily: 'KhmerFont',
                                        ),
                                      ),

                                      const SizedBox(height: 30),

                                      // BUTTONS
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: OutlinedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                    ),
                                                side: BorderSide(
                                                  color: Colors.grey.shade400,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                              ),
                                              child: const Text(
                                                "អត់",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'KhmerFont',
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 14),

                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _calculateFinalScore();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignQuizScreen(),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.deepPurple,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                              ),
                                              child: const Text(
                                                "ទៅមុខ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'KhmerFont',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          _nextQuestion();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      _currentIndex == _questions.length - 1
                          ? 'បញ្ចប់'
                          : 'ទៅមុខ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'KhmerFont',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOption(String answerText, int optionValue) {
    bool isSelected = _selectedAnswerIndex == optionValue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF6A5AE0), Color(0xFF8B7BFF)],
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.deepPurple.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            setState(() {
              _selectedAnswerIndex = optionValue;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 18,
                          color: Colors.deepPurple,
                        )
                      : null,
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    answerText,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                      fontFamily: 'KhmerFont',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
