import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

import 'cancellation_token.dart';
import 'cancellation_token_source.dart';
import 'retry_helper.dart';

class HttpClientHelper {
  static Client _httpClient = new Client();

  static Future<Response> get(url,
      {Map<String, String> headers,
      CancellationToken cancelToken,
      int millisecondsDelay = 100,
      int retries = 3}) async {
    cancelToken?.throwIfCancellationRequested();
    return await RetryHelper.tryRun<Response>(() {
      return CancellationTokenSource.register(cancelToken, _httpClient.get(url, headers: headers));
    },
        cancelToken: cancelToken,
        millisecondsDelay: millisecondsDelay,
        retries: retries);
  }

  static Future<Response> post(url,
      {Map<String, String> headers,
      body,
      Encoding encoding,
      CancellationToken cancelToken,
      int millisecondsDelay = 100,
      int retries = 3}) async {
//    var requestFuture =
//        _httpClient.post(url, headers: headers, body: body, encoding: encoding);

    cancelToken?.throwIfCancellationRequested();

    return await RetryHelper.tryRun<Response>(() {
      return CancellationTokenSource.register(cancelToken, _httpClient.post(url, headers: headers, body: body, encoding: encoding));
    },
        cancelToken: cancelToken,
        millisecondsDelay: millisecondsDelay,
        retries: retries);
  }
}
