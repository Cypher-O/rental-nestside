class RegisterRequestModel {
  const RegisterRequestModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.role = 'tenant',
  });

  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phone;
  final String role;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        if (phone != null) 'phone': phone,
        'role': role,
      };
}
