import 'package:flutter/foundation.dart';
import 'employe.dart';
import 'formation.dart';

class Certification {
  final int id;
  final String titre;
  final DateTime dateObtention; // Changed to DateTime
  final String notes;
  final String statut;
  final Employe employe; // Changed to Employe object
  final Formation formation; // Changed to Formation object

  Certification({
    required this.id,
    required this.titre,
    required this.dateObtention,
    required this.notes,
    required this.statut,
    required this.employe, // Use Employe object
    required this.formation, // Use Formation object
  });

  // Factory method to create a Certification object from JSON
  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['id'],
      titre: json['titre'],
      dateObtention: DateTime.parse(json['dateObtention']), // Parse date string to DateTime
      notes: json['notes'],
      statut: json['statut'],
      employe: Employe.fromJson(json['employe']), // Parse Employe object
      formation: Formation.fromJson(json['formation']), // Parse Formation object
    );
  }

  // Method to convert a Certification object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'dateObtention': dateObtention.toIso8601String(), // Convert DateTime to ISO 8601 string
      'notes': notes,
      'statut': statut,
      'employe': employe.toJson(), // Convert Employe object to JSON
      'formation': formation.toJson(), // Convert Formation object to JSON
    };
  }
}
