import 'package:intl/intl.dart';
import 'package:webpfe/controllers/EmployeController.dart';
import 'package:webpfe/models/Formation.dart';


class Planning {
  int? id;
  String statut;
  DateTime dateDebut;
  DateTime dateFin;
  List<Formation> formations;
  List<Employe> employes;

  Planning({
    this.id,
    required this.statut,
    required this.dateDebut,
    required this.dateFin,
    required this.formations,
    required this.employes,
  });

  // Factory method to parse JSON data
  factory Planning.fromJson(Map<String, dynamic> json) {
    return Planning(
      id: json['id'],
      statut: json['statut'],
      dateDebut: DateTime.parse(json['dateDebut']),
      dateFin: DateTime.parse(json['dateFin']),
      formations: (json['formations'] as List)
          .map((formation) => Formation.fromJson(formation))
          .toList(),
      employes: (json['employes'] as List)
          .map((employe) => Employe.fromJson(employe))
          .toList(),
    );
  }
  // Method to convert Planning object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'statut': statut,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'formations': formations.map((formation) => formation.toJson()).toList(),
      'employes': employes.map((employe) => employe.toJson()).toList(),
    };
  }

  
}

class PostPlanning {
  // int? id;
  String statut;
  DateTime dateDebut;
  DateTime dateFin;
  List<int> formations;
  List<int> employes;

  PostPlanning({
    required this.statut,
    required this.dateDebut,
    required this.dateFin,
    required this.formations,
    required this.employes,
  });

  // Factory method to parse JSON data
  factory PostPlanning.fromJson(Map<String, dynamic> json) {
    return PostPlanning(
      statut: json['statut'],
      dateDebut: DateTime.parse(json['dateDebut']),
      dateFin: DateTime.parse(json['dateFin']),
      formations: List<int>.from(json['formationIds']),
      employes: List<int>.from(json['employeIds']),
    );
  }

  // Method to convert Planning object to JSON
  Map<String, dynamic> toJson() {
    return {
      'statut': statut,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'formationIds': formations,
      'employeIds': employes,
    };
  }
}
