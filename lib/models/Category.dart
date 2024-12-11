class Category {
  final int id;
  final String description;
  final String designation;

  Category({required this.id, required this.description, required this.designation});

  // Factory constructor for parsing JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      description: json['description'],
      designation: json['designation'],
    );
  }

  // Convert Category to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'designation': designation,
    };
  }
}
