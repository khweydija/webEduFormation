class SignupResponse {
  bool success;
  int? id;
  String? nom;
  String? email;
  String? username;

  SignupResponse({required this.success, this.id, this.nom, this.email, this.username});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: true,  // Assuming response indicates success directly
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      username: json['username'],
    );
  }

  get message => null;
}

