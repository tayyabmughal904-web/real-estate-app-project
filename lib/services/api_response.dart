class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int statusCode;
  final String? error;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode = 200,
    this.error,
  });

  factory ApiResponse.success(T data, {String? message, int statusCode = 200}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String error, {int statusCode = 400, T? data}) {
    return ApiResponse<T>(
      success: false,
      error: error,
      message: error,
      statusCode: statusCode,
      data: data,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, statusCode: $statusCode, message: $message, data: $data, error: $error)';
  }
}
