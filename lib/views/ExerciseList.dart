import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/views/AddExerciseScreen.dart';

import '../models/Exercise.dart';
import '../widgets/exercise_card.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({super.key});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}




class _ExerciseListState extends State<ExerciseList> {

  // Test exercise data
  final List<Exercise> exercises = List.generate(
    10, // Create 10 exercise cards for testing
        (index) => Exercise(
      'Push Up',
      'Chest',
      'https://v2.exercisedb.io/image/cP6H94bE3LKxL5', [
      "Sit on the cable machine with your back straight and feet flat on the ground.",
      "Grasp the handles with an overhand grip, slightly wider than shoulder-width apart.",
      "Lean back slightly and pull the handles towards your chest, squeezing your shoulder blades together.",
      "Pause for a moment at the peak of the movement, then slowly release the handles back to the starting position.",
      "Repeat for the desired number of repetitions."
    ] // Replace with actual GIF URLs
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to NewScreen when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExerciseScreen()),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
            childAspectRatio: 0.70,
          ),
          itemCount: exercises.length,
          itemBuilder: (context, index){
            return ExerciseCard(exercise: exercises[index]);
          }),
    );
  }
}
