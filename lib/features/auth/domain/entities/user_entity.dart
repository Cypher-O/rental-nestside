import '../../../../core/enums/app_enums.dart';

class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.role,
    this.isVerified = false,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final UserRole role;
  final bool isVerified;

  String get fullName => '$firstName $lastName';
  bool get isLandlord => role == UserRole.landlord;
  bool get isTenant => role == UserRole.tenant;
}
