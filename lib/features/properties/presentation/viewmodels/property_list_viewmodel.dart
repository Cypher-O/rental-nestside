import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/property_repository.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/constants/app_constants.dart';
import 'property_list_state.dart';

class PropertyListViewModel extends StateNotifier<PropertyListState> {
  PropertyListViewModel(this._repository) : super(const PropertyListState());

  final PropertyRepository _repository;

  Future<void> loadProperties({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        status: PropertyListStatus.loading,
        properties: [],
        currentPage: 1,
        hasMore: true,
        clearError: true,
      );
    } else {
      state = state.copyWith(status: PropertyListStatus.loading);
    }

    final result = await _repository.getProperties(
      city: state.selectedCity.isNotEmpty ? state.selectedCity : null,
      propertyType: state.selectedType,
      page: 1,
      pageSize: AppConstants.defaultPageSize,
    );

    if (result.isSuccess) {
      final props = result.data!;
      state = state.copyWith(
        status: PropertyListStatus.success,
        properties: props,
        currentPage: 1,
        hasMore: props.length >= AppConstants.defaultPageSize,
      );
    } else {
      state = state.copyWith(
        status: PropertyListStatus.failure,
        errorMessage: result.errorOrEmpty,
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;

    final result = await _repository.getProperties(
      city: state.selectedCity.isNotEmpty ? state.selectedCity : null,
      propertyType: state.selectedType,
      page: nextPage,
      pageSize: AppConstants.defaultPageSize,
    );

    if (result.isSuccess) {
      final newProps = result.data!;
      state = state.copyWith(
        properties: [...state.properties, ...newProps],
        currentPage: nextPage,
        hasMore: newProps.length >= AppConstants.defaultPageSize,
        isLoadingMore: false,
      );
    } else {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void setTypeFilter(String? type) {
    if (type == state.selectedType) {
      state = state.copyWith(clearType: true);
    } else {
      state = state.copyWith(selectedType: type);
    }
    loadProperties(refresh: true);
  }

  void setCityFilter(String city) {
    state = state.copyWith(selectedCity: city);
    loadProperties(refresh: true);
  }

  void clearFilters() {
    state = state.copyWith(
      clearType: true,
      selectedCity: '',
    );
    loadProperties(refresh: true);
  }
}
