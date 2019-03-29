
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_picture_select/util/ToastUtil.dart';

class dioHttpUtil {

  Dio dio;
  BaseOptions baseOptions;

  static const String GET = 'GET';
  static const String POST = 'POST';
  static const String PUT = 'PUT';
  static const String PATCH = 'PATCH';
  static const String DELETE = 'DELETE';

  static dioHttpUtil instance;
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
      baseUrl: "https://www.baidu.com/",
      connectTimeout: 8000,  //连接超时时间
      receiveTimeout: 10000, //回调超时时间
//      maxRedirects: 5,  //重定向最大次数。
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
    dio.interceptors.add(LogInterceptor(responseBody: false)); //日志
//    dio.interceptors.add(CookieManager(CookieJar())); //Cookie管理
  }

  doGet(url, {cancelToken}) async {
    print('doGet-url：$url ');
    Response response;
    try {
      response = await dio.get(
        url,
        cancelToken: cancelToken
      );
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('doGet-cancel! ' + e.message);
        ToastUtil.toast('doPost-cancel!');
      }
      print('doGet-error::$e');
      ToastUtil.toast('doGet-error:'+e.message);
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
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('doPost-cancel! ' + e.message);
        ToastUtil.toast('doPost-cancel!');
      }
      print('doPost-error::$e.message');
      ToastUtil.toast('doGet-error:'+e.message);
    }
    return response;
  }
  requestJsonBody(url, {jsonBody, cancelToken}) async {
    print('requestJsonBody-url：$url ,body: $jsonBody');
    Response response;
    try {
      response = await dio.request(
        url,
        data: jsonBody,
        cancelToken: cancelToken,
        options: Options(method: POST),
      );
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('requestJsonBody-cancel! ' + e.message);
        ToastUtil.toast('doPost-cancel!');
      }
      print('requestJsonBody-error::$e.message');
      ToastUtil.toast('doGet-error:'+e.message);
    }
    return response;
  }
  requestFormData(url, {formData, cancelToken}) async {
    print('requestFormData-url：$url ,formdata: $formData');
    Response response;
    try {
      response = await dio.request(
        url,
        data: formData,
        cancelToken: cancelToken,
        options: Options(method: POST),
      );
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('requestFormData-cancel! ' + e.message);
        ToastUtil.toast('doPost-cancel!');
      }
      print('requestFormData-error::$e.message');
      ToastUtil.toast('doGet-error:'+e.message);
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
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('downLoadFile-cancel! ' + e.message);
        ToastUtil.toast('doPost-cancel!');
      }
      print('downLoadFile-error::$e.message');
      ToastUtil.toast('doGet-error:'+e.message);
    }
    return response;
  }


}
