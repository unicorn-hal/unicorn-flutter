class ApiResponse {
  final int statusCode;
  final String message;
  final Map<String, dynamic> data;

  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data,
    };
  }
}
