import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/booking_remote_data_source.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';
import '../viewmodels/booking_state.dart';
import '../viewmodels/booking_list_viewmodel.dart';
import '../viewmodels/booking_detail_viewmodel.dart';
import '../../../../core/di/service_locator.dart';

final bookingRemoteDataSourceProvider =
    Provider<BookingRemoteDataSource>((ref) {
  return BookingRemoteDataSourceImpl(ref.read(apiClientProvider));
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepositoryImpl(ref.read(bookingRemoteDataSourceProvider));
});

final bookingListViewModelProvider =
    StateNotifierProvider<BookingListViewModel, BookingListState>((ref) {
  return BookingListViewModel(ref.read(bookingRepositoryProvider));
});

final bookingDetailViewModelProvider =
    StateNotifierProvider<BookingDetailViewModel, BookingDetailState>((ref) {
  return BookingDetailViewModel(ref.read(bookingRepositoryProvider), ref);
});
