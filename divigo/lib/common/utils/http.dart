import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'deviceInfo.dart';

const host = 'https://api.divcow.com/api';
const apiKey = 'cw1pgqa2k6mea3zc';

// 재시도 설정
const int maxRetries = 3; // 최대 재시도 횟수
const Duration retryDelay = Duration(seconds: 2); // 재시도 간격

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

  if (token != null) result['token'] = token;
  if (refreshToken != null) result['refreshToken'] = refreshToken;

  return result;
}

Future<bool> checkNetworkConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

Future<List<dynamic>> httpList(
    {required String path, Map<String, dynamic>? queryParameters}) async {
  int retryCount = 0;

  while (retryCount < maxRetries) {
    try {
      if (!await checkNetworkConnection()) {
        await Future.delayed(retryDelay);
        retryCount++;
        continue;
      }

      var dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 3);

      var response = await dio.get('$host$path',
          options: Options(headers: await getHeader()),
          queryParameters: queryParameters);

      if (response.statusCode == 200) {
        var body = response.data;
        List<dynamic> list;

        if (body.runtimeType == List<dynamic>) {
          list = body;
        } else {
          list = body['list'];
        }
        return list;
      } else {
        throw response.data;
      }
    } on DioException catch (e) {
      log(path);
      log('DioException: ${e.message} (Attempt ${retryCount + 1}/$maxRetries)');

      if (retryCount < maxRetries - 1) {
        await Future.delayed(retryDelay);
        retryCount++;
        continue;
      }
      rethrow;
    } catch (e) {
      log(path);
      log(e.toString());
      rethrow;
    }
  }

  throw DioException(
    requestOptions: RequestOptions(path: path),
    error: '서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.',
    type: DioExceptionType.connectionError,
  );
}

Future<List<dynamic>> httpListWithCode(
    {required String path, Map<String, dynamic>? queryParameters}) async {
  int retryCount = 0;

  while (retryCount < maxRetries) {
    try {
      if (!await checkNetworkConnection()) {
        await Future.delayed(retryDelay);
        retryCount++;
        continue;
      }

      var dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 3);

      var response = await dio.get('$host$path',
          options: Options(headers: await getHeader()),
          queryParameters: queryParameters);

      if (response.statusCode == 200) {
        return response.data['result']['list'];
      } else {
        throw response.data;
      }
    } on DioException catch (e) {
      log(path);
      log('DioException: ${e.message} (Attempt ${retryCount + 1}/$maxRetries)');

      if (retryCount < maxRetries - 1) {
        await Future.delayed(retryDelay);
        retryCount++;
        continue;
      }
      rethrow;
    } catch (e) {
      log(path);
      log(e.toString());
      rethrow;
    }
  }

  throw DioException(
    requestOptions: RequestOptions(path: path),
    error: '서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.',
    type: DioExceptionType.connectionError,
  );
}

Future httpGetWithCode(
    {required String path, Map<String, dynamic>? queryParameters}) async {
  int retryCount = 0;

  while (retryCount < maxRetries) {
    try {
      if (!await checkNetworkConnection()) {
        await Future.delayed(retryDelay);
        retryCount++;
        continue;
      }

      var dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 3);

      var response = await dio.get('$host$path',
          options: Options(headers: await getHeader()),
          queryParameters: queryParameters);

      if (response.statusCode == 200) {
        return response.data['result'];
      } else {
        throw response.data;
      }
    } on DioException catch (e) {
      log(path);
      log('DioException: ${e.message} (Attempt ${retryCount + 1}/$maxRetries)');

      if (retryCount < maxRetries - 1) {
        await Future.delayed(retryDelay);
        retryCount++;
        continue;
      }
      rethrow;
    } catch (e) {
      log(path);
      log(e.toString());
      rethrow;
    }
  }

  throw DioException(
    requestOptions: RequestOptions(path: path),
    error: '서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.',
    type: DioExceptionType.connectionError,
  );
}

Future httpPost({required String path, dynamic params}) async {
  int retryCount = 0;
  var param = params ?? {};

  while (retryCount < maxRetries) {
    try {
      if (!await checkNetworkConnection()) {
        await Future.delayed(retryDelay);
        retryCount++;
        continue;
      }

      var dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 3);

      var header = await getHeader();
      var response = await dio.post('$host$path',
          options: Options(headers: header), data: param);

      log('>>>>>>>>>>>>>>>>>>>>>$response.data.toString()');

      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          return response.data;
        }
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      log(path);
      log('DioException: ${e.message} (Attempt ${retryCount + 1}/$maxRetries)');

      if (retryCount < maxRetries - 1) {
        await Future.delayed(retryDelay);
        retryCount++;
        continue;
      }
      return '서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.';
    } catch (e) {
      log(path);
      log(e.toString());
      return e.toString();
    }
  }

  return '서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.';
}

//@TODO:: http api들 dio로 변경
Future dioUpload({required String path, required dynamic params}) async {
  int retryCount = 0;

  while (retryCount < maxRetries) {
    try {
      if (!await checkNetworkConnection()) {
        await Future.delayed(retryDelay);
        retryCount++;
        continue;
      }

      const storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');
      var refreshToken = await storage.read(key: 'refreshToken');
      var info = await deviceInfo();

      var dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 3);

      var response = await dio.post('$host$path',
          options: Options(headers: {
            'api_key': apiKey,
            'device': info['id'],
            'token': token,
            'refreshToken': refreshToken,
            'Content-Type': 'multipart/form-data'
          }),
          data: params);

      return response.data;
    } on DioException catch (e) {
      log('DioException: ${e.message} (Attempt ${retryCount + 1}/$maxRetries)');

      if (retryCount < maxRetries - 1) {
        await Future.delayed(retryDelay);
        retryCount++;
        continue;
      }
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  throw DioException(
    requestOptions: RequestOptions(path: path),
    error: '서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.',
    type: DioExceptionType.connectionError,
  );
}
