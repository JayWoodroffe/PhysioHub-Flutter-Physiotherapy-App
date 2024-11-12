class Exercise{
  final String id; //for API exercise ID
  final String name;
  final String targetMuscle;
  late final String gifUrl;
  final List<String>? instructions;
  late int sets;
  late int reps;

  Exercise(this.id, this.name, this.targetMuscle, this.gifUrl, [this.instructions, this.sets = 0, this.reps = 0]);

  // factory constructor for creating an Exercise instance from JSON
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      json['id'] as String,
      json['name'] as String,
      json['target'] as String,
      json['gifUrl'] as String,
      (json['instructions'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  //serialising to map for firestore, excluding the gifURl
  Map<String, dynamic> toFirestore(){
    return {
      'id': id,
      'name': name,
      'targetMuscle': targetMuscle,
      'instructions': instructions,
      'sets': sets,
      'reps': reps,
    };
  }

  //creating an exercise instance from firestore data
  factory Exercise.fromFirestore(Map<String, dynamic> data) {
    return Exercise(
      data['id'] as String,
      data['name'] as String,
      data['targetMuscle'] as String,
      '', // gifUrl is empty here since it won't be in Firestore
      (data['instructions'] as List<dynamic>?)?.map((e) => e as String).toList(),
      data['sets'] ?? 0,
      data['reps'] ?? 0,
    );
  }

}