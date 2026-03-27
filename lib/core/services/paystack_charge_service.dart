import 'dart:convert';
import 'package:dio/dio.dart';

/// Paystack mobile charge API — uses the PUBLIC key.
/// Mirrors what Paystack's iOS/Android SDKs do under the hood.
class PaystackChargeService {
  PaystackChargeService(this.publicKey)
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://standard.paystack.co',
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            responseType: ResponseType.json,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

  final String publicKey;
  final Dio _dio;

  Options get _authOptions => Options(
        headers: {'Authorization': 'Bearer $publicKey'},
        responseType: ResponseType.json,
      );

  Map<String, dynamic> _decode(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    if (raw is String) return json.decode(raw) as Map<String, dynamic>;
    throw FormatException('Unexpected response type: ${raw.runtimeType}');
  }

  /// Initial card charge.
  /// Returns a [ChargeResponse] — check [ChargeResponse.status].
  Future<ChargeResponse> chargeCard({
    required String email,
    required int amountKobo,
    required String reference,
    required String number,
    required String cvv,
    required int expiryMonth,
    required int expiryYear,
  }) async {
    try {
      final resp = await _dio.post(
        '/charge',
        options: _authOptions,
        data: {
          'email': email,
          'amount': amountKobo,
          'reference': reference,
          'card': {
            'number': number,
            'cvv': cvv,
            'expiry_month': expiryMonth,
            'expiry_year': expiryYear,
          },
        },
      );
      return ChargeResponse.fromJson(_decode(_decode(resp.data)['data']));
    } on DioException catch (e) {
      final msg = (e.response?.data is Map)
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      return ChargeResponse.failed(msg?.toString() ?? 'Charge failed');
    }
  }

  Future<ChargeResponse> submitPin({
    required String pin,
    required String reference,
  }) async {
    try {
      final resp = await _dio.post(
        '/charge/submit_pin',
        options: _authOptions,
        data: {'pin': pin, 'reference': reference},
      );
      return ChargeResponse.fromJson(_decode(_decode(resp.data)['data']));
    } on DioException catch (e) {
      final msg = (e.response?.data is Map)
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      return ChargeResponse.failed(msg?.toString() ?? 'PIN submission failed');
    }
  }

  Future<ChargeResponse> submitOtp({
    required String otp,
    required String reference,
  }) async {
    try {
      final resp = await _dio.post(
        '/charge/submit_otp',
        options: _authOptions,
        data: {'otp': otp, 'reference': reference},
      );
      return ChargeResponse.fromJson(_decode(_decode(resp.data)['data']));
    } on DioException catch (e) {
      final msg = (e.response?.data is Map)
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      return ChargeResponse.failed(msg?.toString() ?? 'OTP submission failed');
    }
  }
}

class ChargeResponse {
  const ChargeResponse({
    required this.status,
    required this.reference,
    this.message,
    this.displayText,
  });

  factory ChargeResponse.fromJson(Map<String, dynamic> json) {
    return ChargeResponse(
      status: json['status'] as String? ?? 'failed',
      reference: json['reference'] as String? ?? '',
      message: json['message'] as String?,
      displayText: json['display_text'] as String?,
    );
  }

  factory ChargeResponse.failed(String message) {
    return ChargeResponse(status: 'failed', reference: '', message: message);
  }

  /// `success` | `send_pin` | `send_otp` | `send_phone` | `failed`
  final String status;
  final String reference;
  final String? message;
  final String? displayText;

  bool get isSuccess => status == 'success';
  bool get needsPin => status == 'send_pin';
  bool get needsOtp => status == 'send_otp';
  bool get isFailed => status == 'failed';
}
