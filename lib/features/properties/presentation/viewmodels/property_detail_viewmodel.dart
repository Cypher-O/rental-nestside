import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/repositories/property_repository.dart';
import '../../../../core/enums/app_enums.dart';
import '../providers/property_provider.dart';
import 'property_detail_state.dart';

class PropertyDetailViewModel extends StateNotifier<PropertyDetailState> {
  PropertyDetailViewModel(this._repository, this._ref)
      : super(const PropertyDetailState());

  final PropertyRepository _repository;
  final Ref _ref;

  Future<void> loadProperty(String id) async {
    state = state.copyWith(status: PropertyDetailStatus.loading);

    final result = await _repository.getPropertyById(id);

    if (result.isSuccess) {
      state = state.copyWith(
        status: PropertyDetailStatus.success,
        property: result.data,
      );
    } else {
      state = state.copyWith(
        status: PropertyDetailStatus.failure,
        errorMessage: result.errorOrEmpty,
      );
    }
  }

  Future<bool> deleteProperty(String id) async {
    state = state.copyWith(isDeleting: true);
    final result = await _repository.deleteProperty(id);
    state = state.copyWith(isDeleting: false);
    if (result.isSuccess) {
      _ref.invalidate(propertyListViewModelProvider);
      _ref.invalidate(myListingsViewModelProvider);
    }
    return result.isSuccess;
  }

  Future<bool> createProperty({
    required String title,
    required String description,
    required String address,
    required String city,
    required String state_,
    required String country,
    required double pricePerDay,
    required String propertyType,
    required int bedrooms,
    required int bathrooms,
    required int maxGuests,
    required List<String> amenities,
    required List<String> images,
  }) async {
    state = state.copyWith(status: PropertyDetailStatus.loading);

    final result = await _repository.createProperty(
      title: title,
      description: description,
      address: address,
      city: city,
      state: state_,
      country: country,
      pricePerDay: pricePerDay,
      propertyType: propertyType,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      maxGuests: maxGuests,
      amenities: amenities,
      images: images,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        status: PropertyDetailStatus.success,
        property: result.data,
      );
      _ref.invalidate(propertyListViewModelProvider);
      _ref.invalidate(myListingsViewModelProvider);
      return true;
    } else {
      state = state.copyWith(
        status: PropertyDetailStatus.failure,
        errorMessage: result.errorOrEmpty,
      );
      return false;
    }
  }

  Future<List<String>?> uploadImages(String propertyId, List<XFile> files) async {
    final result = await _repository.uploadImages(propertyId, files);
    if (result.isSuccess) {
      // Reload so the detail state reflects the newly uploaded images
      await loadProperty(propertyId);
      _ref.invalidate(myListingsViewModelProvider);
    }
    return result.isSuccess ? result.data : null;
  }

  Future<bool> updateProperty(
      String id, Map<String, dynamic> data) async {
    state = state.copyWith(status: PropertyDetailStatus.loading);

    final result =
        await _repository.updateProperty(id: id, data: data);

    if (result.isSuccess) {
      state = state.copyWith(
        status: PropertyDetailStatus.success,
        property: result.data,
      );
      _ref.invalidate(propertyListViewModelProvider);
      _ref.invalidate(myListingsViewModelProvider);
      return true;
    } else {
      state = state.copyWith(
        status: PropertyDetailStatus.failure,
        errorMessage: result.errorOrEmpty,
      );
      return false;
    }
  }
}
