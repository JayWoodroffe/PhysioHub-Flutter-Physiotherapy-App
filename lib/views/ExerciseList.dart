import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/views/AddExerciseScreen.dart';

import '../controllers/ExerciseController.dart';
import '../models/Exercise.dart';
import '../widgets/exercise_card.dart';

/*Class that displays the workouts for a given patient.
Exercises are queried from the patients collection and returned as a list. Each
exercise is displayed in an exercise_card widget. Doctors are able to select and
delete exercises from this list.
 */
class ExerciseList extends StatefulWidget {
  final String patientId;

  const ExerciseList({required this.patientId});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  late Future<List<Exercise>> _exercisesFuture; //exercises of the given patient
  bool selectionMode =
      false; //selectionMode will allow the doctor to delete selected exercises
  Set<String> selectedExerciseIds = {}; //to track the selected exercises by Id

  @override
  void initState() {
    super.initState();
    //retrieve the exercises for the patient
    _exercisesFuture =
        ExerciseController().getExercisesForPatient(widget.patientId);
  }

  //turn on/off selection mode and clear the selected exercises if turning off
  void toggleSelectionMode() {
    setState(() {
      selectionMode = !selectionMode;
      if (!selectionMode) {
        selectedExerciseIds.clear();
      }
    });
  }

  //update the selection state for a specific exercise
  void toggleExerciseSelection(String exerciseId) {
    setState(() {
      if (selectedExerciseIds.contains(exerciseId)) {
        selectedExerciseIds.remove(exerciseId);
      } else {
        selectedExerciseIds.add(exerciseId);
      }
    });
  }

  Future<bool> _onWillPop() async {
    // If we are in selection mode, we exit the selection mode instead of popping the route
    if (selectionMode) {
      setState(() {
        selectionMode = false;
        selectedExerciseIds.clear(); // Clear selected exercises
      });
      return false; // Prevent the default back navigation behavior
    }
    return true; // Allow normal back navigation if not in selection mode
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: selectionMode
            ? FloatingActionButton(
                onPressed: () async{
                  //delete the exercises from the database
                  await ExerciseController().deleteExercises(widget.patientId, selectedExerciseIds.toList());
                  setState(()  {
                    selectionMode = false;
                    selectedExerciseIds.clear();
                    _exercisesFuture = ExerciseController().getExercisesForPatient(widget.patientId);
                  });
                },
                backgroundColor: Colors.red,
                child: Icon(Icons.delete, color: Colors.white),
              )
            : FloatingActionButton(
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
                child: Icon(Icons.add, color: Colors.white,),
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
                      selectionMode: selectionMode,
                      isSelected:
                          selectedExerciseIds.contains(exercises[index].id),
                      onLongPress: () {
                        toggleSelectionMode();
                        toggleExerciseSelection(exercises[index].id);
                      },
                      //selection mode on long press
                      onSelect: (isSelected) =>
                          toggleExerciseSelection((exercises[index].id)));
                },
              );
            }
          },
        ),
      ),
    );
  }
}
