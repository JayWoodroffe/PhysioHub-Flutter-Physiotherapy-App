import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config.dart';
import '../models/Exercise.dart';

class ExerciseApiService{
  static const String _baseUrl = 'https://exercisedb.p.rapidapi.com';
  final String _apiKey = Config.apiKey; // Use API key from Config

  //api call using the name of the exercises
  Future<List<Exercise>> searchExercisesByName(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/exercises/name/$query'),
      headers: {
        'X-RapidAPI-Key': _apiKey,
        'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Exercise.fromJson(json)).toList(); //converting the list to exerciseModels
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  //method to retrieve the up to date gifurl for the exercise
  Future<String?> fetchGifUrl(String exerciseId) async {
    print(exerciseId);
    final url = Uri.parse('$_baseUrl/exercises/exercise/$exerciseId'); //uses the id of exercise from the API
    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
    },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final url = data['gifUrl'] as String?;

      return url;

    } else {
      throw Exception('Failed to fetch gifUrl');
    }
  }

  Future<List<Exercise>> getExercisesByMuscleGroup(String muscleGroup) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/exercises/target/$muscleGroup'),
      headers: {
        'X-RapidAPI-Key': _apiKey,
        'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}