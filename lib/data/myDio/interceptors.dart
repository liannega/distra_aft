part of "my_dio.dart";

class CustomInterceptors extends Interceptor {
  // static final _header = {"content-type": "application/json; charset=utf-8"};
  final String _token;

  CustomInterceptors(this._token);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // options.headers.addAll(_header);
    // options.headers.addAll({'x-token': token});

    if (_token.isNotEmpty) {
      options.headers.addAll({'authorization': "Bearer $_token"});
    }

    if (kDebugMode) {
      print('REQUEST[${options.method}] => PATH: ${options.path}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
          'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      // print('RESPONSE DATA => ${response.data ?? "null"}');
    }
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print(
          'ERROR[${err.response?.statusCode}] => DATA: ${err.response?.data}');
      // print('ERROR[${err.response?.statusCode}] => DATA: ${err.requestOptions.data}');
    }
    super.onError(err, handler);
    return Future(() => err);
  }
}
