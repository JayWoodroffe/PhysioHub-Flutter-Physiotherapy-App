import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/providers/ExerciseProvider.dart';
import 'package:physio_hub_flutter/services/ExerciseApiService.dart';
import 'package:provider/provider.dart';

import '../models/Exercise.dart';
import '../widgets/exercise_card.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

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
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search exercises by name',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white60),
          ),
          style: TextStyle(color: Colors.white),
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
          : ListView.builder(
        itemCount: exerciseProvider.exercises.length,
        itemBuilder: (context, index) {
          return ExerciseCard(
            exercise: exerciseProvider.exercises[index],
          );
        },
      ),
    );
  }
}
