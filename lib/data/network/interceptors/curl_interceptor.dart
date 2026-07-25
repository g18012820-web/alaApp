import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class CurlInterceptor extends Interceptor {
  final bool? shouldLogOnSuccess;
  final bool shouldConvertFormData;

  CurlInterceptor({
    this.shouldLogOnSuccess,
    this.shouldConvertFormData = true,
  });

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    _logCurl(error.requestOptions);
    handler.next(error);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (shouldLogOnSuccess == true) {
      _logCurl(response.requestOptions);
    }
    handler.next(response);
  }

  void _logCurl(RequestOptions requestOptions) {
    try {
      final curlCommand = _generateCurlCommand(requestOptions);
      log(curlCommand);
    } catch (e) {
      log('❌ Can\'t create cURL from request: $e');
    }
  }

  String _generateCurlCommand(RequestOptions options) {
    final List<String> curlParts = ['curl -i'];

    _addHttpMethod(curlParts, options.method);
    _addHeaders(curlParts, options.headers);
    _addBodyData(curlParts, options.data);
    _addUrl(curlParts, options.uri.toString());

    return curlParts.join(' \\\n\t');
  }

  void _addHttpMethod(List<String> curlParts, String method) {
    if (method.toUpperCase() != 'GET') {
      curlParts.add('-X $method');
    }
  }

  void _addHeaders(List<String> curlParts, Map<String, dynamic> headers) {
    headers.forEach((key, value) {
      if (key != 'Cookie') {
        curlParts.add('-H "$key: $value"');
      }
    });
  }

  void _addBodyData(List<String> curlParts, dynamic data) {
    if (data == null) return;

    dynamic requestData = data;
    if (requestData is FormData && shouldConvertFormData) {
      requestData = Map.fromEntries(requestData.fields);
    }

    final encodedData = json.encode(requestData).replaceAll('"', '\\"');
    curlParts.add('-d "$encodedData"');
  }

  void _addUrl(List<String> curlParts, String url) {
    curlParts.add('"$url"');
  }
}
