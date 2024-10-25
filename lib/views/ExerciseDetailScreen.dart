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
      body: SingleChildScrollView(
        // Wrap everything in SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Theme.of(context).splashColor,
                    elevation: 2,
                    margin: const EdgeInsets.all(6.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        // Set the desired border radius
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
                    ),
                  ),
                  SizedBox(height: 10), // Add spacing between elements
                  Text(
                    '$sets sets x $reps reps',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10), // Add spacing between elements
                  Text(
                    'Instructions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Column(
              children: widget.exercise.instructions?.map((instruction) {
                    return ListTile(
                      title: Text(instruction),
                    );
                  }).toList() ??
                  [], // Ensure instructions are mapped properly
            ),
          ],
        ),
      ),
    );
  }
}
