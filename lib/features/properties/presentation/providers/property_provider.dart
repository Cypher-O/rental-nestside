import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/property_remote_data_source.dart';
import '../../data/repositories/property_repository_impl.dart';
import '../../domain/repositories/property_repository.dart';
import '../viewmodels/property_list_state.dart';
import '../viewmodels/property_list_viewmodel.dart';
import '../viewmodels/property_detail_state.dart';
import '../viewmodels/property_detail_viewmodel.dart';
import '../../../../core/di/service_locator.dart';

final propertyRemoteDataSourceProvider =
    Provider<PropertyRemoteDataSource>((ref) {
  return PropertyRemoteDataSourceImpl(ref.read(apiClientProvider));
});

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  return PropertyRepositoryImpl(ref.read(propertyRemoteDataSourceProvider));
});

final propertyListViewModelProvider =
    StateNotifierProvider<PropertyListViewModel, PropertyListState>((ref) {
  return PropertyListViewModel(ref.read(propertyRepositoryProvider));
});

final propertyDetailViewModelProvider =
    StateNotifierProvider<PropertyDetailViewModel, PropertyDetailState>((ref) {
  return PropertyDetailViewModel(ref.read(propertyRepositoryProvider), ref);
});

// My listings (for landlord)
final myListingsViewModelProvider =
    StateNotifierProvider<PropertyListViewModel, PropertyListState>((ref) {
  return PropertyListViewModel(ref.read(propertyRepositoryProvider));
});
