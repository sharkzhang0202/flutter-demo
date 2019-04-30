import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';


// post通用请求方法
Future request(String url, String funcName, {params}) async {
  try {
    print('=========================$funcName 方法开始执行啦！！！=======================');
    Response response;
    var dio = new Dio();
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    if (params == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: params);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('出错啦！！！==================================================》 $e');
  }
}
