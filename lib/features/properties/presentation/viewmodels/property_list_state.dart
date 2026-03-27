import '../../domain/entities/property_entity.dart';
import '../../../../core/enums/app_enums.dart';

class PropertyListState {
  const PropertyListState({
    this.status = PropertyListStatus.initial,
    this.properties = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.searchQuery = '',
    this.selectedType,
    this.selectedCity = '',
  });

  final PropertyListStatus status;
  final List<PropertyEntity> properties;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final String searchQuery;
  final String? selectedType;
  final String selectedCity;

  PropertyListState copyWith({
    PropertyListStatus? status,
    List<PropertyEntity>? properties,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    String? searchQuery,
    String? selectedType,
    String? selectedCity,
    bool clearError = false,
    bool clearType = false,
  }) {
    return PropertyListState(
      status: status ?? this.status,
      properties: properties ?? this.properties,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      selectedCity: selectedCity ?? this.selectedCity,
    );
  }

  bool get isLoading => status == PropertyListStatus.loading;
  bool get isSuccess => status == PropertyListStatus.success;
  bool get isFailure => status == PropertyListStatus.failure;
}
