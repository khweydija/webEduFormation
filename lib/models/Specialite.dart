import 'Departement.dart';

class Specialite {
  final int idSpecialite;
  final String nom;
  final String description;
  final Departement departement;

  Specialite({
    required this.idSpecialite,
    required this.nom,
    required this.description,
    required this.departement,
  });

  // Factory constructor for parsing JSON
  factory Specialite.fromJson(Map<String, dynamic> json) {
    return Specialite(
      idSpecialite: json['idSpecialite'],
      nom: json['nom'],
      description: json['description'],
      departement: Departement.fromJson(json['departement']),
    );
  }

  // Convert Specialite to JSON
  Map<String, dynamic> toJson() {
    return {
      'idSpecialite': idSpecialite,
      'nom': nom,
      'description': description,
      'departement': departement.toJson(),
    };
  }
}
