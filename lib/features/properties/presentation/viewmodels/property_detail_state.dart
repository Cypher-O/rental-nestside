import '../../domain/entities/property_entity.dart';
import '../../../../core/enums/app_enums.dart';

class PropertyDetailState {
  const PropertyDetailState({
    this.status = PropertyDetailStatus.initial,
    this.property,
    this.errorMessage,
    this.isDeleting = false,
  });

  final PropertyDetailStatus status;
  final PropertyEntity? property;
  final String? errorMessage;
  final bool isDeleting;

  PropertyDetailState copyWith({
    PropertyDetailStatus? status,
    PropertyEntity? property,
    String? errorMessage,
    bool? isDeleting,
  }) {
    return PropertyDetailState(
      status: status ?? this.status,
      property: property ?? this.property,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  bool get isLoading => status == PropertyDetailStatus.loading;
  bool get isSuccess => status == PropertyDetailStatus.success;
  bool get isFailure => status == PropertyDetailStatus.failure;
}
