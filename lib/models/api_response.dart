class ApiResponse<T> {
  T? data;
  String message;
  bool isError;

  ApiResponse({this.data, this.message = '', this.isError = false});
}
