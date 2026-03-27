import '../../domain/entities/user_entity.dart';
import '../../../../core/enums/app_enums.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.role,
    this.isVerified = false,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'tenant',
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] as String?,
    );
  }

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String role;
  final bool isVerified;
  final String? createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'role': role,
        'is_verified': isVerified,
        'created_at': createdAt,
      };

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        role: UserRoleX.fromString(role),
        isVerified: isVerified,
      );
}
