import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/models/Exercise.dart';

import '../controllers/ExerciseController.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;
  final bool isPreview; //flag to indicate if we're in preview mode
  final String patientId;
  final String? gifUrl;

  const ExerciseDetailScreen({required this.exercise, required this.patientId, this.isPreview = false, this.gifUrl});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  Future<void> _addExerciseToWorkout() async {
    try {
      await ExerciseController().addExerciseToPatient(
        widget.patientId,
        widget.exercise,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exercise added to workout')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add exercise: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('gifurl at details screen: ${widget.exercise.gifUrl}');
    return Scaffold(
      //only show the add exercise button if we are here from the add exercise screen
      floatingActionButton: widget.isPreview
          ? FloatingActionButton.extended(
              onPressed: () => _addExerciseToWorkout(),
              backgroundColor: Theme.of(context).splashColor,
              label: Text('Add to workout'),
            )
          : null,
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
                          widget.gifUrl?? widget.exercise.gifUrl,
                          height: 350,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print(error);
                            return Center(child: Text('Image not available'));
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (!widget
                      .isPreview) // show sets x reps if the exercise is already added to the workout plan
                    Text(
                      '${widget.exercise.sets} sets x ${widget.exercise.reps} reps',
                      style: TextStyle(fontSize: 16),
                    ),
                  SizedBox(height: 10),
                  if (widget.isPreview)
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Select Sets and Reps:",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).splashColor)),
                          Row(
                            children: [
                              Text("Sets:"),
                              //buttons to increase or decrease the number of sets
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (widget.exercise.sets > 1)
                                        widget.exercise.sets--;
                                    });
                                  },
                                  icon: Icon(Icons.remove)),
                              Text('${widget.exercise.sets}'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    widget.exercise.sets++;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Reps:"),
                              //buttons to increase or decrease the number of reps
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (widget.exercise.reps > 1)
                                        widget.exercise.reps--;
                                    });
                                  },
                                  icon: Icon(Icons.remove)),
                              Text('${widget.exercise.reps}'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    widget.exercise.reps++;
                                  });
                                },
                              ),
                            ],
                          )
                        ]),
                  const SizedBox(height: 10.0),
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
