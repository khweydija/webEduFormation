class Formation {
  int? id;
  String titre;
  String description;
  String type;
  String categorieDesignation;
  String? url;
  int formateurId;
  String? photo; // Add the photo attribute

  Formation({
    this.id,
    required this.titre,
    required this.description,
    required this.type,
    required this.categorieDesignation,
    this.url,
    required this.formateurId,
    this.photo, // Initialize photo in constructor
  });
  factory Formation.fromJson(Map<String, dynamic> json) {
    return Formation(
      id: json['id_Formation'],
      titre: json['titre'],
      description: json['description'],
      type: json['type'],
      categorieDesignation: json['categorie']['designation'],
      url: json['url'] ?? null, // Handle null value for url
      formateurId: json['formateur']['id'],
      photo: json['photo'], // Map photo attribute
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'description': description,
      'type': type,
      'categorieDesignation': categorieDesignation,

      'url': url,
      'formateurId': formateurId,
      'photo': photo, // Include photo in JSON
    };
  }
}
