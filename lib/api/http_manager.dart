import 'dart:developer';

import 'package:dio/dio.dart';

import 'urls.dart';
import '../releans_verify.dart';

class HttpManager {
  //set base option to dio
  BaseOptions baseOptions = BaseOptions(
    followRedirects: false,
    baseUrl: Urls.baseUrl,
    validateStatus: (status) {
      return status! < 500;
    },
    contentType: Headers.formUrlEncodedContentType,
    responseType: ResponseType.json,
  );

  //exporting options with Authorization header
  BaseOptions exportOption(BaseOptions options) {
    Map<String, dynamic> header = {
      "Accept": "application/json",
    };
    options.headers.addAll(header);

    if (ReleansVerify().getKey() != null &&
        ReleansVerify().getKey()!.isNotEmpty) {
      options.headers["Authorization"] = "Bearer ${ReleansVerify().getKey()}";
    }
    return options;
  }

  //handle errors
  Map<String, dynamic> dioErrorHandle({DioError? error, String? stringError}) {
    if (error != null) {
      log(
        error.toString(),
        name: "ERROR",
      );
    } else {
      log(
        stringError!,
        name: "ERROR",
      );
    }
    if (error != null) {
      switch (error.type) {
        case DioErrorType.response:
          {
            log(error.response.toString());

            return {
              "error": {"message": "something went wrong"}
            };
          }
        default:
          {
            return {
              "error": {"message": "something went wrong"}
            };
          }
      }
    } else {
      return {
        "error": {"message": stringError}
      };
    }
  }

  //sending post request
  Future<dynamic> post({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    Dio dio = Dio(exportOption(baseOptions));

    log(
      url,
      name: "POST URL",
    );
    log(
      data.toString(),
      name: "POST DATA",
    );
    try {
      final response = await dio.post(
        url,
        data: data,
      );

      log(
        response.toString(),
        name: "POST Response: $url",
      );

      return response.data;
    } on DioError catch (error) {
      return dioErrorHandle(error: error);
    }
  }
}
