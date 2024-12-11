class Departement {
  final int idDepartement;
  final String nom;
  final String description;

  Departement({
    required this.idDepartement,
    required this.nom,
    required this.description,
  });

  // Factory constructor for parsing JSON
  factory Departement.fromJson(Map<String, dynamic> json) {
    return Departement(
      idDepartement: json['idDepartement'],
      nom: json['nom'],
      description: json['description'],
    );
  }

  // Convert Departement to JSON
  Map<String, dynamic> toJson() {
    return {
      'idDepartement': idDepartement,
      'nom': nom,
      'description': description,
    };
  }
}
