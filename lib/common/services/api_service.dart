import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as a;
import 'package:renergy_app/global.dart';

import '../constants/constants.dart';
import 'storage_service.dart';

class Api {
  static final Api _instance = Api._internal();
  factory Api() => _instance;

  late Dio dio;

  Api._internal() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        followRedirects: false,
        contentType: 'application/json; charset=utf-8',
        responseType: ResponseType.json,
        validateStatus: (status) => true
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
          error = changeExceptionMessage(error);
          return handler.next(error);
        },
      ),
    );
  }

  DioException changeExceptionMessage(DioException error) {
    String errMsg;

    try {
      if (error.response != null) {
        if (error.response!.data['message'] != null) {
          errMsg = error.response!.data['message'];
        } else {
          throw 'error';
        }
      } else {
        throw 'error';
      }
    } catch (e) {
      switch (error.type) {
        case DioExceptionType.cancel:
          errMsg = AppStrings.httpRequestCancelled.tr;
        case DioExceptionType.connectionTimeout:
          errMsg = AppStrings.httpConnectionTimeout.tr;
        case DioExceptionType.sendTimeout:
          errMsg = AppStrings.httpRequestTimeout.tr;
        case DioExceptionType.receiveTimeout:
          errMsg = AppStrings.httpReceiveTimeout.tr;
        case DioExceptionType.badResponse:
          {
            try {
              int errCode = error.response!.statusCode!;
              switch (errCode) {
                case 400:
                  errMsg = AppStrings.httpError400.tr;
                case 401:
                  errMsg = AppStrings.httpError401.tr;
                case 403:
                  errMsg = AppStrings.httpError403.tr;
                case 404:
                  errMsg = AppStrings.httpError404.tr;
                case 405:
                  errMsg = AppStrings.httpError405.tr;
                case 500:
                  errMsg = AppStrings.httpError500.tr;
                case 502:
                  errMsg = AppStrings.httpError502.tr;
                case 503:
                  errMsg = AppStrings.httpError503.tr;
                case 505:
                  errMsg = AppStrings.httpError505.tr;
                default:
                  errMsg = AppStrings.unknownError.tr;
              }
            } catch (e) {
              errMsg = AppStrings.unknownError.tr;
            }
          }
        default:
          errMsg = AppStrings.unknownError.tr;
      }
    }

    return DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      type: error.type,
      error: error.error,
      stackTrace: error.stackTrace,
      message: errMsg,
    );
  }

  Options? getOptions() {
    Options requestOptions = Options();
    requestOptions.headers = requestOptions.headers ?? {};

    String? token = StorageService.to.getString(storageAccessToken);
    token ??= '';

    if (token.isNotEmpty) {
      requestOptions.headers!.addAll({'Authorization': 'Bearer $token'});
    }

    // String lang = TranslationService.locale.languageCode;
    // requestOptions.headers!.addAll({'Accept-Language': lang});

    // String region = RegionService.to.region;
    // requestOptions.headers!.addAll({'Accept-Region': region});

    return requestOptions;
  }

  Future<Response> get(
    endpoint, {
    Map<String, dynamic>? data,
    String? fullUrl,
  }) async {
    return await requestApi(
      endpoint,
      fullUrl: fullUrl,
      data: data,
      method: 'get',
    );
  }

  Future<Response> post(
    endpoint, {
    String? fullUrl,
    Map<String, dynamic>? data,
  }) async {
    return await requestApi(
      endpoint,
      fullUrl: fullUrl,
      method: 'post',
      data: data,
    );
  }

  Future<Response> getBytes(
    String endpoint, {
    String? fullUrl,
  }) async {
    final url = fullUrl ?? '$httpBaseUrl/$endpoint';
    try {
      final baseOptions = getOptions();
      final options = Options(
        headers: baseOptions?.headers,
        responseType: ResponseType.bytes,
      );
      final response = await dio.get(url, options: options);
      if ((response.statusCode ?? 0) >= 300) {
        throw response.statusMessage ?? 'Download error';
      }
      return response;
    } on DioException catch (e) {
      final err = changeExceptionMessage(e);
      throw err.message ?? 'Unknown error';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> put(
    endpoint, {
    String? fullUrl,
    Map<String, dynamic>? data,
  }) async {
    return await requestApi(
      endpoint,
      fullUrl: fullUrl,
      method: 'put',
      data: data,
    );
  }

  Future<Response> patch(
    endpoint, {
    String? fullUrl,
  }) async {
    return await requestApi(
      endpoint,
      fullUrl: fullUrl,
      method: 'patch',
    );
  }

  Future<Response> delete(
    endpoint, {
    String? fullUrl,
  }) async {
    return await requestApi(
      endpoint,
      fullUrl: fullUrl,
      method: 'delete',
    );
  }

  Future<Response> dummy(
    endpoint, {
    Map<String, dynamic>? data,
    String? fullUrl,
    Map<String, dynamic>? returnData,
  }) async {
    return await requestApi(
      endpoint,
      fullUrl: fullUrl,
      method: 'dummy',
      data: data,
      returnData: returnData,
    );
  }

  Future<Response> requestApi(
    String endpoint, {
    String method = 'post',
    Map<String, dynamic>? data,
    String? fullUrl,
    Map<String, dynamic>? returnData,
  }) async {
    final url = fullUrl ?? '$httpBaseUrl/$endpoint';

    Response? response;

    try {
      switch (method) {
        case 'get':
          {
            response = await dio.get(url, options: getOptions());
            break;
          }
        case 'post':
          {
            if (data == null) {
              response = await dio.post(url, options: getOptions());
            } else {
              response = await dio.post(url, data: FormData.fromMap(data), options: getOptions());
            }
            break;
          }
        case 'put':
          {
            response = await dio.put(url, data: data, options: getOptions());
            break;
          }
        case 'patch':
          {
            response = await dio.patch(url, options: getOptions());
            break;
          }
        case 'delete':
          {
            response = await dio.delete(url, options: getOptions());
            break;
          }
        case 'dummy':
          {
            response = Response(
              requestOptions: RequestOptions(path: url),
              data: jsonEncode(returnData),
              statusCode: 200,
            );
            break;
          }
        default:
          {
            response = await dio.post(url, data: data, options: getOptions());
          }
      }

      if (response.statusCode! >= 300 ) {
        if (response.data['message'].toString().isNotEmpty) {
          throw response.data['message'];
        } else {
          throw response.statusMessage ?? 'Unknown error';
        }
      }
    } on DioException catch (e) {
      print("DIO ERROR: ${e.type}");
  print("STATUS: ${e.response?.statusCode}");
  print("DATA: ${e.response?.data}");
      if (e.response?.statusCode == 401) {
        StorageService.to.remove(storageAccessToken);
        Global.isLoginValid = false;
      }

      if(e.message is String){
        throw e.message.toString();
      }
      else{
         throw 'e.message type error: ${e.message.runtimeType}';
      }
      
    } catch (e) {
      throw e.toString();
    }

    return response;
  }
}
