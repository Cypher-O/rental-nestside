import 'package:image_picker/image_picker.dart';
import '../../../../core/network/result.dart';
import '../entities/property_entity.dart';

abstract class PropertyRepository {
  Future<Result<List<PropertyEntity>>> getProperties({
    String? city,
    String? state,
    String? propertyType,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    int page = 1,
    int pageSize = 20,
  });

  Future<Result<PropertyEntity>> getPropertyById(String id);

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
  });

  Future<Result<PropertyEntity>> updateProperty({
    required String id,
    required Map<String, dynamic> data,
  });

  Future<Result<void>> deleteProperty(String id);

  Future<Result<List<PropertyEntity>>> getMyProperties();
  Future<Result<List<String>>> uploadImages(String propertyId, List<XFile> files);
}
