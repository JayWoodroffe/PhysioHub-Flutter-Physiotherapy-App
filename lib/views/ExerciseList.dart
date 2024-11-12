import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/views/AddExerciseScreen.dart';

import '../controllers/ExerciseController.dart';
import '../models/Exercise.dart';
import '../widgets/exercise_card.dart';

class ExerciseList extends StatefulWidget {
  final String patientId;

  const ExerciseList({required this.patientId});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  late Future<List<Exercise>> _exercisesFuture;

  @override
  void initState(){
    super.initState();
    _exercisesFuture = ExerciseController().getExercisesForPatient(widget.patientId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to NewScreen when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddExerciseScreen(patientId: this.widget.patientId)),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Exercise>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is being fetched, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error, display an error message
            return Center(child: Text('Error loading exercises'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If no exercises are found, display a message
            return Center(child: Text('No exercises found.'));
          } else {
            // If data is available, show the exercises
            final exercises = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                childAspectRatio: 0.70,
              ),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return ExerciseCard(
                  exercise: exercises[index],
                  patientId: widget.patientId,
                );
              },
            );
          }
        },
      ),
    );
  }
}