class Result<T> {
  Result._({
    required this.isSuccess,
    this.data,
    this.error,
  });

  factory Result.success(T data) => Result._(data: data, isSuccess: true);
  factory Result.failure(String error) =>
      Result._(error: error, isSuccess: false);

  final T? data;
  final String? error;
  final bool isSuccess;

  bool get isFailure => !isSuccess;

  T get dataOrThrow {
    if (isSuccess && data != null) return data!;
    throw Exception(error ?? 'Unknown error');
  }

  T? get dataOrNull => data;
  String get errorOrEmpty => error ?? '';
}
