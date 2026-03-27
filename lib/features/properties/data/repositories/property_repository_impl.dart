import 'package:image_picker/image_picker.dart';
import '../../../../core/network/result.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/property_repository.dart';
import '../datasources/property_remote_data_source.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  PropertyRepositoryImpl(this._remoteDataSource);

  final PropertyRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<PropertyEntity>>> getProperties({
    String? city,
    String? state,
    String? propertyType,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await _remoteDataSource.getProperties(
      city: city,
      state: state,
      propertyType: propertyType,
      minPrice: minPrice,
      maxPrice: maxPrice,
      bedrooms: bedrooms,
      page: page,
      pageSize: pageSize,
    );
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Result<PropertyEntity>> getPropertyById(String id) async {
    final result = await _remoteDataSource.getPropertyById(id);
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.toEntity());
  }

  @override
  Future<Result<PropertyEntity>> createProperty({
    required String title,
    required String description,
    required String address,
    required String city,
    required String state,
    required String country,
    required double pricePerDay,
    required String propertyType,
    required int bedrooms,
    required int bathrooms,
    required int maxGuests,
    required List<String> amenities,
    required List<String> images,
  }) async {
    final result = await _remoteDataSource.createProperty({
      'title': title,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'price_per_day': pricePerDay,
      'property_type': propertyType,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'max_guests': maxGuests,
      'amenities': amenities,
      'images': images,
    });
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.toEntity());
  }

  @override
  Future<Result<PropertyEntity>> updateProperty({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final result = await _remoteDataSource.updateProperty(id, data);
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.toEntity());
  }

  @override
  Future<Result<void>> deleteProperty(String id) {
    return _remoteDataSource.deleteProperty(id);
  }

  @override
  Future<Result<List<String>>> uploadImages(String propertyId, List<XFile> files) {
    return _remoteDataSource.uploadImages(propertyId, files);
  }

  @override
  Future<Result<List<PropertyEntity>>> getMyProperties() async {
    final result = await _remoteDataSource.getMyProperties();
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.map((m) => m.toEntity()).toList());
  }
}
