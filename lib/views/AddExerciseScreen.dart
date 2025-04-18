import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/providers/ExerciseProvider.dart';
import 'package:physio_hub_flutter/services/ExerciseApiService.dart';
import 'package:provider/provider.dart';

import '../models/Exercise.dart';
import '../widgets/exercise_card.dart';

class AddExerciseScreen extends StatefulWidget {
  final String patientId;

  const AddExerciseScreen({required this.patientId});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //provider allows us to query the api
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search exercises by name',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Theme.of(context).primaryColor),
          ),
          style: TextStyle(color: Theme.of(context).primaryColor),
          onSubmitted: (query) {
            // Trigger a search when the user submits the text field
            exerciseProvider.searchExercisesByName(query);
          },
        ),
      ),
      body: exerciseProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : exerciseProvider.error != null
              ? Center(child: Text('Error: ${exerciseProvider.error}'))
              : exerciseProvider.exercises.isEmpty
                  ? Center(child: Text('No exercises found.'))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 2.0,
                        childAspectRatio: 0.70,
                      ),
                      itemCount: exerciseProvider.exercises.length,
                      itemBuilder: (context, index) {
                        return ExerciseCard(
                          exercise: exerciseProvider.exercises[index],
                          patientId: this.widget.patientId,
                          showSetsReps: false,
                        );
                      },
                    ),
    );
  }
}
