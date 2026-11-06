class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
  final dynamic error;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? (json['status'] == 'success') ?? true,
      message: json['message'] ?? '',
      data: (json['data'] != null && fromJsonT != null)
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      statusCode: json['statusCode'] ?? json['status_code'],
      error: json['error'] ?? json['errors'],
    );
  }

  factory ApiResponse.error({
    required String message,
    int? statusCode,
    dynamic error,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      error: error,
    );
  }
}
