class ReturnResult<T> {
  final bool state;
  final String message;
  final T? data;
  final bool codeExpired; // Flag to indicate if OTP code has expired (backend-only enforcement)

  ReturnResult({
    required this.state,
    required this.message,
    this.data,
    this.codeExpired = false,
  });
}