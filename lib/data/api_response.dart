class ApiResponse<T> {
  late int statusCode;
  late String meta;
  late bool succeeded;
  late String message;
  late String errors;
  late T data;

  ApiResponse.fromJson(Map json, this.data) {
    this.statusCode = json["statusCode"] ?? 0;
    this.meta = json["meta"]?? "";
    this.succeeded = json["succeeded"]?? false;
    this.message = json["message"]?? false;
    this.errors = json["errors"]?? "";
  }
}
