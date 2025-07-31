import 'dart:async';
import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Make sure this import is correct

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Get things done.',
      'subtitle': 'Just a click away from\nplanning your tasks.',
    },
    {
      'title': 'Stay Organized.',
      'subtitle': 'Keep track of your daily\nwork with ease.',
    },
    {'title': 'Achieve More.', 'subtitle': 'Reach your goals\nstep by step.'},
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % _pages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Bottom-right curved purple shape
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFF7367F0),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(200)),
              ),
            ),
          ),

          // PageView Slider Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Check icon box
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7367F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.check, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 32),

                // Slider using PageView
                SizedBox(
                  height: 100,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Text(
                            _pages[index]['title']!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E2D),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _pages[index]['subtitle']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),

                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildDot(isActive: index == _currentPage),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Arrow button
          Positioned(
            bottom: 32,
            right: 24,
            child: GestureDetector(
              behavior:
                  HitTestBehavior.translucent, // Makes the whole area clickable
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20), // Increases touch area
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7367F0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({bool isActive = false}) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF7367F0) : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }
}
