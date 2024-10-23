import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/widgets/bottom_navigation_bar.dart';
import 'package:physio_hub_flutter/widgets/exercise_card.dart';

import '../models/Exercise.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int selectedIndex = 1; //bottom navigation index

  // Test exercise data
  final List<Exercise> exercises = List.generate(
    10, // Create 10 exercise cards for testing
        (index) => Exercise(
      'Push Up',
      'Chest',
      'https://v2.exercisedb.io/image/EsOqQ8Z50wRW7L', // Replace with actual GIF URLs
    ),
  );

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/messages');
        break;
      case 2:
        Navigator.pushNamed(context, '/appointments');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: selectedIndex,
          onItemTapped: onItemTapped
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 6.0,
            childAspectRatio: 0.75,
          ),
          itemCount: exercises.length,
          itemBuilder: (context, index){
            return ExerciseCard(exercise: exercises[index]);
          }),
    );
  }
}
