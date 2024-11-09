import 'package:flutter/material.dart';
import '../models/Exercise.dart';
import '../views/ExerciseDetailScreen.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  const ExerciseCard({required this.exercise});

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  int sets = 3;
  int reps = 12;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExerciseDetailScreen(exercise: this.widget.exercise),
            ),
          );
        },
      child: Card(
          color: Colors.green.shade50,
          elevation: 5,
          margin: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //display gif from api
                Image.network(
                  widget.exercise.gifUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) { //error if image isnt available
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: Text(
                        'Image not available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  widget.exercise.name,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 4),
                Text('$sets x $reps')
              ],
            ),
          )
      ),
    );

  }
}
