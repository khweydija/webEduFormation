// models/login_response.dart
class LoginResponse {
  final String token;
  final int expiresIn;
  final String userType;
  final Map<String, dynamic> userData;

  LoginResponse({
    required this.token,
    required this.expiresIn,
    required this.userType,
    required this.userData,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      expiresIn: json['expiresIn'],
      userType: json['userType'],
      userData: json['userData'],
    );
  }


   

   
  
}
