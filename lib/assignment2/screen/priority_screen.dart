import 'package:flutter/material.dart';
import 'package:project2/assignment2/model/priority_model.dart';
import 'package:project2/assignment2/data/prority_data.dart';
import 'package:project2/assignment2/data/notifier.dart';
import 'package:project2/assignment2/screen/result_screen.dart';

class PriorityQuizScreen extends StatefulWidget {
  const PriorityQuizScreen({super.key});

  @override
  State<PriorityQuizScreen> createState() => _PriorityQuizScreenState();
}

class _PriorityQuizScreenState extends State<PriorityQuizScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  final List<PriorityQuestion> _questions = PriorityQuizData.priorityQuestions;
  final Map<int, int> _selectedAnswersHistory = {};
  int finalScore = 0;
  final List<PriorityQuestion> _randomizedQuestions = [];

  @override
  void initState() {
    super.initState();
    _randomizedQuestions.addAll(PriorityQuizData.priorityQuestions);
    _randomizedQuestions.shuffle();
    // Register THIS screen's score calculator with the global timer
    onTimeoutScoreCalculator = _calculateFinalScore;
  }

  void _makeanswers() {
    if (_selectedAnswerIndex != null) {
      _selectedAnswersHistory[_currentIndex] = _selectedAnswerIndex!;
    }
  }

  void _calculateFinalScore() {
    int tempscore = 0;
    _selectedAnswersHistory.forEach((questionIndex, chosenAnswerIndex) {
      final actualQuestion = _randomizedQuestions[questionIndex];
      if (chosenAnswerIndex == actualQuestion.correctAnswer) {
        tempscore++;
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
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  bool isLowTime = seconds < 60;
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
            const SizedBox(height: 4),
            Text(
              'សំណួរទី ${_currentIndex + 1} / ${_questions.length} ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: tt.labelLarge!.fontSize,
                color: Colors.black,
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
              child: ValueListenableBuilder<int>(
                valueListenable: progressValue,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    minHeight: 10,
                    value: value / 45,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(Colors.deepPurple),
                  );
                },
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6A5AE0),
                                    Color(0xFF8B7BFF),
                                  ],
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
                            ValueListenableBuilder(
                              valueListenable: totalanswer,
                              builder: (context, value, child) {
                                return ValueListenableBuilder(
                                  valueListenable: currentanswer,
                                  builder: (context, value, child) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF6A5AE0),
                                            Color(0xFF8B7BFF),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        '${currentanswer.value}/${totalanswer.value}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'KhmerFont',
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
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
                                      color: Colors.deepPurple.withValues(
                                        alpha: 0.1,
                                      ),
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
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.deepPurple.withValues(
                                          alpha: 0.08,
                                        ),
                                        Colors.blue.withValues(alpha: 0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.deepPurple.withValues(
                                        alpha: 0.15,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Container(
                                    height: 170,
                                    width: 170,
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.08,
                                          ),
                                          blurRadius: 18,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.asset(
                                        currentQuestion.imagePath,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildAnswerOption(currentQuestion.answer0, 0),
                        _buildAnswerOption(currentQuestion.answer1, 1),
                        _buildAnswerOption(currentQuestion.answer2, 2),
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
                  child: ValueListenableBuilder<int>(
                    valueListenable: progressValue,
                    builder: (context, value, child) {
                      return OutlinedButton(
                        onPressed: () {
                          if (_currentIndex > 0) {
                            currentanswer.value--;
                            progressValue.value--;
                            _previousQuestion();
                          }
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
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ValueListenableBuilder<int>(
                    valueListenable: progressValue,
                    builder: (context, value, child) {
                      return ElevatedButton(
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
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(snackBar);
                            return;
                          }

                          _makeanswers();

                          // Check if the current answer is wrong
                          final currentQuestion =
                              _randomizedQuestions[_currentIndex];
                          if (_selectedAnswerIndex !=
                              currentQuestion.correctAnswer) {
                            isAutoFail.value = true;
                            quizTimer?.cancel();
                            _calculateFinalScore();
                            progressValue.value++;
                            currentanswer.value++;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResultScreen(),
                              ),
                              (route) => false,
                            );
                            return;
                          }

                          if (_currentIndex == _questions.length - 1) {
                            quizTimer?.cancel();
                            _calculateFinalScore();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResultScreen(),
                              ),
                              (route) => false,
                            );
                          } else {
                            progressValue.value++;
                            currentanswer.value++;
                            _nextQuestion();
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
                      );
                    },
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
    final tt = Theme.of(context).textTheme;
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
                      fontSize: tt.headlineSmall!.copyWith(fontSize: 20).fontSize,
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
