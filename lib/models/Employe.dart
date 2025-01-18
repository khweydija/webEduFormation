import 'dart:convert';

class Employe {
  final int id;
  final String email;
  final String nom;
  final String prenom;
  final String diplome;
  final String photo;

  Employe({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.diplome,
    required this.photo,
  });

  factory Employe.fromJson(Map<String, dynamic> json) {
    return Employe(
      id: json['id'],
      email: json['email'],
      nom: json['nom'],
      prenom: json['prenom'],
      diplome: json['diplome'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'diplome': diplome,
      'photo': photo,
    };
  }
}
