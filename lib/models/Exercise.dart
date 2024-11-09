class Exercise{
  final String name;
  final String targetMuscle;
  final String gifUrl;
  final List<String>? instructions;
  const Exercise(this.name, this.targetMuscle, this.gifUrl, [this.instructions]);

  // factory constructor for creating an Exercise instance from JSON
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      json['name'] as String,
      json['target'] as String,
      json['gifUrl'] as String,
      (json['instructions'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }
}