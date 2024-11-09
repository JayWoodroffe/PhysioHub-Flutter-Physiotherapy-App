import 'package:flutter/material.dart';
import '../models/Exercise.dart';
import '../services/ExerciseApiService.dart';

class ExerciseProvider extends ChangeNotifier {
  final ExerciseApiService apiService = ExerciseApiService();

  // Constructor to initialize with the API service
  ExerciseProvider();

  List<Exercise> _exercises = [];
  List<Exercise> get exercises => _exercises;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Fetch exercises by name
  Future<void> searchExercisesByName(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _exercises = await apiService.searchExercisesByName(query);
      _error = null;
    } catch (e) {
      _exercises = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch exercises by muscle group
  Future<void> filterExercisesByMuscleGroup(String muscleGroup) async {
    _isLoading = true;
    notifyListeners();

    try {
      _exercises = await apiService.getExercisesByMuscleGroup(muscleGroup);
      _error = null;
    } catch (e) {
      _exercises = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
