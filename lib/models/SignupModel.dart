class SignupModel {
  String email;
  String password;
  String nom;

  SignupModel({required this.email, required this.password, required this.nom});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nom': nom,
    };
  }
}