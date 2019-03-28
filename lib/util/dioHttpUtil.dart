
import 'dart:io';

import 'package:dio/dio.dart';

class dioHttpUtil {
  static dioHttpUtil instance;
  Dio dio;
  BaseOptions baseOptions;


  static dioHttpUtil getInstance() {
    print('getInstance');
    if (instance == null) {
      instance = new dioHttpUtil();
    }
    return instance;
  }

  dioHttpUtil() {
    print('配置dio实例');
    // 配置dio实例

    baseOptions = new BaseOptions(
      /// 请求路径，如果 `path` 以 "http(s)"开始, 则 `baseURL` 会被忽略； 否则,
      /// 将会和baseUrl拼接出完整的的url.
//      baseUrl: "https://www.zbg.com/exchange",
      connectTimeout: 5000,
      receiveTimeout: 10000,
//      maxRedirects: 5,  //重定向最大次数。
      // 5s
      headers: {
        HttpHeaders.userAgentHeader: "dio",
        "api": "1.0.0",
      },
      contentType: ContentType.json,
      // Transform the response data to a String encoded with UTF8.
      // The default value is [ResponseType.JSON].
      responseType: ResponseType.plain,
    );

    dio = new Dio(baseOptions);

    dio.interceptors.add(LogInterceptor(responseBody: false)); //开启请求日志

  }

  requestJsonBody(url, {jsonBody, options, cancelToken}) async {
    print('requestJsonBody-url：$url ,body: $jsonBody');
    Response response;
    try {
      response = await dio.request(
        url,
        data: jsonBody,
        cancelToken: cancelToken,
        options: Options(method: options),
      );
      print('requestJsonBody-success::response.data：${response.data}');
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('requestJsonBody-cancel! ' + e.message);
      }
      print('requestJsonBody-error::$e');
    }
    return response;
  }
  doPost(url, {cancelToken}) async {
    print('doPost-url：$url ');
    Response response;
    try {
      response = await dio.post(
        url,
        cancelToken: cancelToken,
      );
      print('doPost-success::response.data：${response.data}');
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('doPost-cancel! ' + e.message);
      }
      print('doPost-error::$e');
    }
    return response;
  }
  doGet(url, {cancelToken}) async {
    print('doGet-url：$url ');
    Response response;
    try {
      response = await dio.get(
        url,
        cancelToken: cancelToken
      );
      print('doGet-success::response.data：${response.data}');
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('doGet-cancel! ' + e.message);
      }
      print('doGet-error::$e');
    }
    return response;
  }

  downLoadFile(url, fileNamePath,progressCallback,{cancelToken}) async {
    print('downLoadFile-url：$url ');
    Response response;
    try {
      response = await dio.download(
          url,
          fileNamePath,
          cancelToken: cancelToken,
          onReceiveProgress: progressCallback,
      );
      print('downLoadFile-success::response.data：${response.data}');
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('downLoadFile-cancel! ' + e.message);
      }
      print('downLoadFile-error::$e');
    }
    return response;
  }


}
