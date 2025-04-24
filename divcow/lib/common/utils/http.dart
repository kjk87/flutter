import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:divcow/common/utils/deviceInfo.dart';
import 'package:divcow/common/utils/session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const host = 'https://api.divcow.com/api';
const apiKey = 'cw1pgqa2k6mea3zc';

Future<Map<String, String>> getHeader() async {
  const storage = FlutterSecureStorage();
  var token = await storage.read(key: 'token');
  var refreshToken = await storage.read(key: 'refreshToken');
  var info = await deviceInfo();
  
  Map<String, String> result = {
    "accept": "application/json",
    "Content-Type": "application/json",
    "api_key": apiKey,
    "device": info['id']
  };

  if(token != null) result['token'] = token;
  if(refreshToken != null) result['refreshToken'] = refreshToken;

  return result;
}

Future<List<dynamic>> httpList({required String path}) async {

  try {
    http.Response response = await http.get(Uri.parse('$host$path'), headers: await getHeader());

    if (response.statusCode == 200) { 

      var body = jsonDecode(response.body);
      List<dynamic> list;
      
      if(body.runtimeType == List<dynamic>) {
        list = body;
      } else {
        list = body['list'];
      }
      return list;
    } else {
      throw response.body;
    }
  } catch (e) {
    log(path);
    log(e.toString());
    rethrow; 
  }
}

Future<List<dynamic>> httpListWithCode({required String path}) async {

  try {
    http.Response response = await http.get(Uri.parse('$host$path'), headers: await getHeader());

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return body['result']['list'];
    } else {
      throw response.body;
    }
  } catch (e) {
    log(path);
    log(e.toString());
    rethrow;
  }
}

Future httpGetWithCode({required String path}) async {

  try {
    http.Response response = await http.get(Uri.parse('$host$path'), headers: await getHeader());

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return body['result'];
    } else {
      throw response.body;
    }
  } catch (e) {
    log(path);
    log(e.toString());
    rethrow;
  }
}

Future httpPost({required String path, dynamic params}) async {
  
  var param = params ?? {};
  var header = await getHeader();
  log(path);
  log(header.toString());
  try {
    http.Response response = await http.post(
      Uri.parse('$host$path'), 
      headers: header,
      body: jsonEncode(param) 
    );

    log('response');
    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      if(response.body.isNotEmpty) {
        var body = jsonDecode(response.body);
        return body;
      }
    } else {
      return response.body;
    }
  } catch (e) {
    log(path);
    log(e.toString());
    return e.toString();
  }
}

//@TODO:: http api들 dio로 변경
Future dioUpload({required String path, required dynamic params}) async {
  
  const storage = FlutterSecureStorage();
  var token = await storage.read(key: 'token');
  var refreshToken = await storage.read(key: 'refreshToken');
  var info = await deviceInfo();

  try {

    var dio = Dio();

    var response = await dio.post(
      '$host$path', 
      options: Options(
        headers: {
          'api_key': apiKey,
          'device': info['id'],
          'token': token,
          'refreshToken': refreshToken,
          'Content-Type': 'multipart/form-data'
        }
      ),
      data: params
    );

    return response.data;

  } catch (e) {
    log(e.toString());
  }
}