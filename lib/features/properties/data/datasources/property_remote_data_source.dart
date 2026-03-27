import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/property_model.dart';

abstract class PropertyRemoteDataSource {
  Future<Result<List<PropertyModel>>> getProperties({
    String? city,
    String? state,
    String? propertyType,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    int page = 1,
    int pageSize = 20,
  });

  Future<Result<PropertyModel>> getPropertyById(String id);

  Future<Result<PropertyModel>> createProperty(Map<String, dynamic> data);

  Future<Result<PropertyModel>> updateProperty(
      String id, Map<String, dynamic> data);

  Future<Result<void>> deleteProperty(String id);

  Future<Result<List<PropertyModel>>> getMyProperties();
  Future<Result<List<String>>> uploadImages(String propertyId, List<XFile> files);
}

class PropertyRemoteDataSourceImpl implements PropertyRemoteDataSource {
  PropertyRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Result<List<PropertyModel>>> getProperties({
    String? city,
    String? state,
    String? propertyType,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    int page = 1,
    int pageSize = 20,
  }) {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (city != null && city.isNotEmpty) 'city': city,
      if (state != null && state.isNotEmpty) 'state': state,
      if (propertyType != null && propertyType.isNotEmpty)
        'property_type': propertyType,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (bedrooms != null) 'bedrooms': bedrooms,
    };

    return _apiClient.get<List<PropertyModel>>(
      endpoint: ApiConstants.properties,
      queryParams: queryParams,
      parser: (data) {
        final list = data is List
            ? data
            : (data is Map ? data['items'] ?? data['properties'] ?? [] : []);
        return (list as List)
            .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<Result<PropertyModel>> getPropertyById(String id) {
    return _apiClient.get<PropertyModel>(
      endpoint: ApiConstants.propertyById(id),
      parser: (data) =>
          PropertyModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<PropertyModel>> createProperty(Map<String, dynamic> data) {
    return _apiClient.post<PropertyModel>(
      endpoint: ApiConstants.properties,
      data: data,
      parser: (data) =>
          PropertyModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<PropertyModel>> updateProperty(
      String id, Map<String, dynamic> data) {
    return _apiClient.put<PropertyModel>(
      endpoint: ApiConstants.propertyById(id),
      data: data,
      parser: (data) =>
          PropertyModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<void>> deleteProperty(String id) {
    return _apiClient.delete(endpoint: ApiConstants.propertyById(id));
  }

  @override
  Future<Result<List<String>>> uploadImages(String propertyId, List<XFile> files) {
    return _apiClient.postMultipartFiles(
      endpoint: ApiConstants.propertyImages(propertyId),
      files: files,
    );
  }

  @override
  Future<Result<List<PropertyModel>>> getMyProperties() {
    return _apiClient.get<List<PropertyModel>>(
      endpoint: ApiConstants.myProperties,
      parser: (data) {
        final list = data is List
            ? data
            : (data is Map ? data['items'] ?? data['properties'] ?? [] : []);
        return (list as List)
            .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
