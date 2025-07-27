import 'package:flutter/material.dart';
import 'package:untitled/view/home_screen.dart';

class InterestSelectionScreen extends StatefulWidget {
  const InterestSelectionScreen({super.key});

  @override
  State<InterestSelectionScreen> createState() => _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  final List<String> interests = [
    'Technology',
    'Health',
    'Sports',
    'Entertainment',
    'Business',
    'Science',
    'Geopolitics',
    'Education',
    'World',
    'India',
    'Social Media',
    'USA',
    'Stock Market',
    'General',

  ];

  final Set<String> selectedInterests = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Select Your Interests',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF071938),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            const Text(
              "Choose topics you'd like to explore",
              style: TextStyle(fontSize: 18, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: interests.map((topic) {
                final isSelected = selectedInterests.contains(topic);
                return ChoiceChip(
                  label: Text(
                    topic,
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Color(0xFF213A50),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Colors.orange,
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.orange),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (_) {
                    setState(() {
                      if (isSelected) {
                        selectedInterests.remove(topic);
                      } else {
                        selectedInterests.add(topic);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

