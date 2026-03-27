import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/buttons/button_icon.dart';
import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/inputs/text_input.dart';
import '../../../../core/widgets/text/app_text.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/enums/app_enums.dart';
import '../providers/property_provider.dart';
import '../widgets/section_title.dart';

class CreatePropertyScreen extends ConsumerStatefulWidget {
  const CreatePropertyScreen({super.key, this.propertyId});

  final String? propertyId;

  bool get isEditing => propertyId != null;

  @override
  ConsumerState<CreatePropertyScreen> createState() =>
      _CreatePropertyScreenState();
}

class _CreatePropertyScreenState
    extends ConsumerState<CreatePropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController =
      TextEditingController(text: AppStrings.countryDefault);
  final _priceController = TextEditingController();
  final _bedroomsController = TextEditingController(text: '1');
  final _bathroomsController = TextEditingController(text: '1');
  final _maxGuestsController = TextEditingController(text: '2');
  final _imageUrlController = TextEditingController();
  final List<XFile> _localImages = [];

  String _selectedType = 'apartment';
  final List<String> _amenities = [];
  final List<String> _images = [];
  bool _populated = false;

  static const List<String> _propertyTypes = [
    'apartment',
    'house',
    'room',
    'studio',
  ];

  static const List<String> _commonAmenities = [
    'WiFi',
    'Air Conditioning',
    'Parking',
    'Swimming Pool',
    'Gym',
    'Laundry',
    'Security',
    'Generator',
    'Water Supply',
    'TV',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(propertyDetailViewModelProvider.notifier)
            .loadProperty(widget.propertyId!);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _priceController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _maxGuestsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _populateForm(property) {
    _titleController.text = property.title;
    _descriptionController.text = property.description ?? '';
    _addressController.text = property.address;
    _cityController.text = property.city;
    _stateController.text = property.state;
    _countryController.text = property.country;
    _priceController.text = property.pricePerDay.toStringAsFixed(0);
    setState(() {
      _selectedType = (property.propertyType as PropertyType).value;
      _amenities
        ..clear()
        ..addAll(property.amenities);
      _images
        ..clear()
        ..addAll(property.images);
      _populated = true;
    });
  }

  void _addImageUrl() {
    final url = _imageUrlController.text.trim();
    if (url.isNotEmpty && !_images.contains(url)) {
      setState(() {
        _images.add(url);
        _imageUrlController.clear();
      });
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage(imageQuality: 80);
    if (files.isEmpty) return;
    setState(() => _localImages.addAll(files));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = ref.read(propertyDetailViewModelProvider.notifier);
    bool success;

    if (widget.isEditing) {
      success = await vm.updateProperty(widget.propertyId!, {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'country': _countryController.text.trim(),
        'price_per_day': double.tryParse(_priceController.text) ?? 0,
        'property_type': _selectedType,
        'bedrooms': int.tryParse(_bedroomsController.text) ?? 1,
        'bathrooms': int.tryParse(_bathroomsController.text) ?? 1,
        'max_guests': int.tryParse(_maxGuestsController.text) ?? 2,
        'amenities': _amenities,
        'images': _images,
      });
    } else {
      success = await vm.createProperty(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        state_: _stateController.text.trim(),
        country: _countryController.text.trim(),
        pricePerDay: double.tryParse(_priceController.text) ?? 0,
        propertyType: _selectedType,
        bedrooms: int.tryParse(_bedroomsController.text) ?? 1,
        bathrooms: int.tryParse(_bathroomsController.text) ?? 1,
        maxGuests: int.tryParse(_maxGuestsController.text) ?? 2,
        amenities: _amenities,
        images: _images,
      );
    }

    if (!mounted) return;

    if (success) {
      // Upload any locally picked images using the property ID
      if (_localImages.isNotEmpty) {
        final propertyId = widget.propertyId ??
            ref.read(propertyDetailViewModelProvider).property?.id;
        if (propertyId != null) {
          await vm.uploadImages(propertyId, _localImages);
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            widget.isEditing
                ? AppStrings.propertyUpdatedSuccess
                : AppStrings.propertyCreatedSuccess,
          ),
          backgroundColor: AppColors.success,
        ),
      );
      ref.read(propertyListViewModelProvider.notifier).loadProperties(refresh: true);
      context.pop();
    } else {
      final error =
          ref.read(propertyDetailViewModelProvider).errorMessage ??
              AppStrings.operationFailed;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(error),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(propertyDetailViewModelProvider);
    final isLoading = detailState.isLoading;

    if (widget.isEditing && !_populated && detailState.property != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateForm(detailState.property!);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: widget.isEditing
            ? AppStrings.editPropertyTitle
            : AppStrings.createProperty,
        onBackPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(label: AppStrings.sectionBasicInfo),
              const SizedBox(height: AppDimensions.spacing12),
              TextInput(
                controller: _titleController,
                label: AppStrings.propertyTitle,
                hint: AppStrings.propertyTitleHint,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: AppDimensions.spacing14),
              TextInput(
                controller: _descriptionController,
                label: AppStrings.description,
                hint: AppStrings.descriptionHint,
                maxLines: 4,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: AppDimensions.spacing20),
              SectionTitle(label: AppStrings.propertyType),
              const SizedBox(height: AppDimensions.spacing12),
              Wrap(
                spacing: AppDimensions.spacing8,
                children: _propertyTypes.map((type) {
                  final isSelected = _selectedType == type;
                  return ChoiceChip(
                    label: AppText(
                      type[0].toUpperCase() + type.substring(1),
                      fontSize: AppTypography.fontSize13,
                      fontWeight: AppTypography.weightMedium,
                      color: isSelected ? AppColors.white : AppColors.textPrimary,
                    ),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedType = type),
                    selectedColor: AppColors.primary,
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.spacing20),
              SectionTitle(label: AppStrings.location),
              const SizedBox(height: AppDimensions.spacing12),
              TextInput(
                controller: _addressController,
                label: AppStrings.address,
                hint: AppStrings.addressHint,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.location_on_outlined,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Address is required'
                    : null,
              ),
              const SizedBox(height: AppDimensions.spacing14),
              Row(
                children: [
                  Expanded(
                    child: TextInput(
                      controller: _cityController,
                      label: AppStrings.city,
                      hint: AppStrings.cityHint,
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: TextInput(
                      controller: _stateController,
                      label: AppStrings.state,
                      hint: AppStrings.stateHint,
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing14),
              TextInput(
                controller: _countryController,
                label: AppStrings.country,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Country is required'
                    : null,
              ),
              const SizedBox(height: AppDimensions.spacing20),
              SectionTitle(label: AppStrings.sectionPricingCapacity),
              const SizedBox(height: AppDimensions.spacing12),
              TextInput(
                controller: _priceController,
                label: AppStrings.pricePerDay,
                hint: AppStrings.pricePerDayHint,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.payments_outlined,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Price is required';
                  if ((double.tryParse(v) ?? 0) <= 0) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacing14),
              Row(
                children: [
                  Expanded(
                    child: TextInput(
                      controller: _bedroomsController,
                      label: AppStrings.bedroomsLabel,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: TextInput(
                      controller: _bathroomsController,
                      label: AppStrings.bathroomsLabel,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: TextInput(
                      controller: _maxGuestsController,
                      label: AppStrings.maxGuests,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing20),
              SectionTitle(label: AppStrings.amenitiesLabel),
              const SizedBox(height: AppDimensions.spacing12),
              Wrap(
                spacing: AppDimensions.spacing8,
                runSpacing: AppDimensions.spacing4,
                children: _commonAmenities.map((amenity) {
                  final selected = _amenities.contains(amenity);
                  return FilterChip(
                    label: AppText(
                      amenity,
                      fontSize: AppTypography.fontSize12,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                    ),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _amenities.add(amenity);
                        } else {
                          _amenities.remove(amenity);
                        }
                      });
                    },
                    selectedColor: AppColors.primary.withAlpha(20),
                    checkmarkColor: AppColors.primary,
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.spacing20),
              SectionTitle(label: AppStrings.sectionImages),
              const SizedBox(height: AppDimensions.spacing12),
              Row(
                children: [
                  Expanded(
                    child: TextInput(
                      controller: _imageUrlController,
                      hint: AppStrings.imageUrlsHint,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _addImageUrl(),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing10),
                  CustomButton.secondary(
                    text: '',
                    onPressed: _addImageUrl,
                    width: AppDimensions.spacing56,
                    height: AppDimensions.inputHeight,
                    icon: const ButtonIcon.material(Icons.link),
                  ),
                  const SizedBox(width: AppDimensions.spacing8),
                  CustomButton.secondary(
                    text: '',
                    onPressed: _pickImages,
                    width: AppDimensions.spacing56,
                    height: AppDimensions.inputHeight,
                    icon: const ButtonIcon.material(Icons.add_photo_alternate_outlined),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing12),
              Wrap(
                spacing: AppDimensions.spacing8,
                runSpacing: AppDimensions.spacing8,
                children: [
                  // Uploaded images
                  ..._images.asMap().entries.map((entry) => Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            child: Image.network(
                              entry.value,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 90,
                                height: 90,
                                color: AppColors.border,
                                child: const Icon(Icons.broken_image_outlined,
                                    color: AppColors.textSecondary),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: () => setState(() => _images.removeAt(entry.key)),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.close,
                                    size: 14, color: AppColors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                  // Locally picked images (uploaded on submit)
                  ..._localImages.asMap().entries.map((entry) => Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            child: Image.file(
                              File(entry.value.path),
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: () => setState(() => _localImages.removeAt(entry.key)),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.close,
                                    size: 14, color: AppColors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing32),
              CustomButton.secondary(
                text: widget.isEditing
                    ? AppStrings.updateListing
                    : AppStrings.saveListing,
                onPressed: _submit,
                isLoading: isLoading,
              ),
              const SizedBox(height: AppDimensions.spacing40),
            ],
          ),
        ),
      ),
    );
  }
}
