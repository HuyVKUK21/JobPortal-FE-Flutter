class User {
  final int userId;
  final String email;
  final String userType;
  final String firstName;
  final String lastName;
  final String? phone;

  User({
    required this.userId,
    required this.email,
    required this.userType,
    required this.firstName,
    required this.lastName,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? 0,
      email: json['email'] ?? '',
      userType: json['userType'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'userType': userType,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    };
  }

  String get fullName => '$firstName $lastName';
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final String token;
  final User user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      user: User.fromJson(json),
    );
  }
}

class RegisterEmployerRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String companyName;
  final String companyIndustry;
  final String companyLocation;
  final String companyWebsite;

  RegisterEmployerRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.companyName,
    required this.companyIndustry,
    required this.companyLocation,
    required this.companyWebsite,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'companyName': companyName,
      'companyIndustry': companyIndustry,
      'companyLocation': companyLocation,
      'companyWebsite': companyWebsite,
    };
  }
}

class RegisterJobSeekerRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String? portfolioLink;

  RegisterJobSeekerRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    this.portfolioLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'portfolioLink': portfolioLink,
    };
  }
}





