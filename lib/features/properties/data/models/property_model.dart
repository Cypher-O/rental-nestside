import '../../domain/entities/property_entity.dart';
import '../../../../core/enums/app_enums.dart';

class PropertyModel {
  const PropertyModel({
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
    this.createdAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String? ?? '',
      ownerId: json['owner_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
      pricePerDay: (json['price_per_day'] as num?)?.toDouble() ?? 0.0,
      propertyType: json['property_type'] as String? ?? 'apartment',
      bedrooms: json['bedrooms'] as int? ?? 0,
      bathrooms: json['bathrooms'] as int? ?? 0,
      maxGuests: json['max_guests'] as int? ?? 1,
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isAvailable: json['is_available'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
    );
  }

  final String id;
  final String ownerId;
  final String title;
  final String? description;
  final String address;
  final String city;
  final String state;
  final String country;
  final double pricePerDay;
  final String propertyType;
  final int bedrooms;
  final int bathrooms;
  final int maxGuests;
  final List<String> amenities;
  final List<String> images;
  final bool isAvailable;
  final String? createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'owner_id': ownerId,
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
        'is_available': isAvailable,
        'created_at': createdAt,
      };

  PropertyEntity toEntity() => PropertyEntity(
        id: id,
        ownerId: ownerId,
        title: title,
        description: description,
        address: address,
        city: city,
        state: state,
        country: country,
        pricePerDay: pricePerDay,
        propertyType: PropertyTypeX.fromString(propertyType),
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        maxGuests: maxGuests,
        amenities: amenities,
        images: images,
        isAvailable: isAvailable,
      );
}
