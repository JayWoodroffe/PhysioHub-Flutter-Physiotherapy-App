import 'package:flutter/material.dart';
import 'package:physio_hub_flutter/services/ExerciseApiService.dart';
import '../models/Exercise.dart';
import '../views/ExerciseDetailScreen.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final bool
  showSetsReps; //sets and reps shouldn't be shown when the user is searching for exercises

  final String patientId;

  const ExerciseCard(
      {required this.exercise, required this.patientId, this.showSetsReps = true});

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  String? gifUrl;
  bool isLoadingGif = false;
  bool selectionMode = false; //checkbox to show
  bool isSelected = false; //checkbox must be checked

  @override
  void initState() {
    super.initState();
    gifUrl = widget.exercise.gifUrl;
    if (gifUrl == null || gifUrl!.isEmpty) {
      print('loading gif');
      loadGif();
    }
  }

  Future<void> loadGif() async {
    setState(() {
      isLoadingGif = true;
    });
    try {
      final fetchedGifUrl =
      await ExerciseApiService().fetchGifUrl(widget.exercise.id);
      setState(() {
        gifUrl = fetchedGifUrl;
        this.widget.exercise.gifUrl = gifUrl!;
        print(this.widget.exercise.gifUrl);
      });
    } catch (e) {
      print("Error loading gifUrl: $e");
    } finally {
      setState(() {
        isLoadingGif = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        setState(() {
          selectionMode = true;
          isSelected = true;
        });
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ExerciseDetailScreen(
                  exercise: this.widget.exercise,
                  patientId: this.widget.patientId,
                  isPreview: !widget.showSetsReps,
                  gifUrl: gifUrl,
                ),
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  isLoadingGif
                      ? Container( //loading the gif
                    height: 150,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                      : Image.network( //displaying the gif
                    gifUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      //error if image isnt available
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
                  Flexible(
                    child: Text(
                      widget.exercise.name,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.showSetsReps) ...[
                    Text('${widget.exercise.sets} x ${widget.exercise.reps}'),
                  ],
                ],
              ),
              if (selectionMode)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Checkbox(value: isSelected, onChanged: (bool? value) {
                    setState(() {
                      isSelected = value ?? false;
                    });
                  },),),
            ],
          ),
        ),
      ),
    );
  }
}
