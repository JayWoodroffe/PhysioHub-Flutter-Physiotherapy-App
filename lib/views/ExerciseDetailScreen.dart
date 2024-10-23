import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/models/Exercise.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int sets = 3;
  int reps = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name, style: TextStyle(fontSize: 25)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black, width: 3), // Thin black border
                  ),
                  child: Image.network(
                    widget.exercise.gifUrl,
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Image not available'));
                    },
                  ),
                ),
                Text(
                  '$sets sets x $reps reps',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Instructions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.exercise.instructions?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.exercise.instructions![index]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
