import '../../../../core/enums/app_enums.dart';

class PropertyEntity {
  const PropertyEntity({
    required this.id,
    required this.ownerId,
    required this.title,
    this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pricePerDay,
    required this.propertyType,
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.maxGuests = 1,
    this.amenities = const [],
    this.images = const [],
    this.isAvailable = true,
  });

  final String id;
  final String ownerId;
  final String title;
  final String? description;
  final String address;
  final String city;
  final String state;
  final String country;
  final double pricePerDay;
  final PropertyType propertyType;
  final int bedrooms;
  final int bathrooms;
  final int maxGuests;
  final List<String> amenities;
  final List<String> images;
  final bool isAvailable;

  String get locationSummary => '$city, $state';
  String get firstImage => images.isNotEmpty ? images.first : '';
}
