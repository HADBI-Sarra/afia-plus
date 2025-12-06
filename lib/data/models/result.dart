class ReturnResult<T> {
  final bool state;
  final String message;
  final T? data;

  ReturnResult({required this.state, required this.message, this.data});
}