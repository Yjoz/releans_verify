import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:releans_verify/models/releans_result.dart';

import 'api/http_manager.dart';
import 'api/urls.dart';
import 'models/channels.dart';

class ReleansVerify with ChangeNotifier {
  String? _apiKey;
  String? _sender;

  Timer? _timer;

  late ValueNotifier<int> remainingSeconds;
  late int delay;

  static final ReleansVerify _singleton = ReleansVerify._internal();
  HttpManager httpManager = HttpManager();

  factory ReleansVerify() {
    return _singleton;
  }

  ReleansVerify._internal();

  //remove current ongoing timer
  disposeTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = null;
    remainingSeconds.value = delay;
    log("timer cancelled");
  }

  //check if there any active timers
  bool isTimerActive() {
    if (_timer != null && _timer!.isActive) {
      return true;
    }
    return false;
  }

  //start timer
  bool startTimer() {
    disposeTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value <= 1) {
        remainingSeconds.value = delay;
        disposeTimer();
      } else {
        remainingSeconds.value--;
      }
    });
    log("new timer created");

    return true;
  }

  /*
  * initialize the releans plugin
  * apiKey and sender is required
  * */
  init(
      {required String apiKey,
      required String sender,
      int resendingDelayInSeconds = 15}) {
    _apiKey = apiKey;
    _sender = sender;
    delay = resendingDelayInSeconds;
    remainingSeconds = ValueNotifier<int>(delay);
    log("api key and sender init done");
  }

  //return apiKey
  String? getKey() {
    return _apiKey;
  }

  /*
  * send verification code
  * mobile number with country code is required
  * */
  Future<ReleansResult> sendCode({
    required String mobile,
    Channel channel = Channel.sms,
  }) async {
    //check apiKey or sender is null
    if (_apiKey == null || _sender == null) {
      log("api key and sender is required. create new sender from dashboard");
      return ReleansResult(
          message: "Api key and sender is required", status: 404);
    }

    if (isTimerActive()) {
      return ReleansResult(
          message: "Please wait another ${remainingSeconds.value} seconds",
          status: 404);
    }

    //sending request to releans API
    var result = await httpManager.post(
        url: Urls.otpSend,
        data: {"sender": _sender, "mobile": mobile, "channel": channel.name});

    if (result != null) {
      try {
        //returning the result object
        ReleansResult result_ = ReleansResult.fromJson(result);

        if (result_.isSuccess()) {
          startTimer();
        }
        return result_;
      } catch (_) {}
    }
    //return error if null
    return ReleansResult(message: "API returns null", status: 404);
  }

  /*
  * verify code
  * mobile number and OTP code is required
  * */
  Future<ReleansResult> verifyCode({
    required String mobile,
    required String code,
  }) async {
    //check apiKey or sender is null
    if (_apiKey == null || _sender == null) {
      log("api key and sender is required. create new sender from dashboard");
      return ReleansResult(
          message: "Api key and sender is required", status: 404);
    }

    //sending request to releans API
    var result = await httpManager
        .post(url: Urls.otpVerify, data: {"mobile": mobile, "code": code});

    if (result != null) {
      try {
        //returning the result object
        return ReleansResult.fromJson(result);
      } catch (_) {}
    }
    //return error if null
    return ReleansResult(message: "API returns null", status: 404);
  }
}
