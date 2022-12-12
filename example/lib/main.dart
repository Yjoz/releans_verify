import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:releans_verify/releans.dart';

void main() {
  //init releans sms by using api key and sender
  //create new sender in dashboard if not exist
  ReleansVerify().init(
      apiKey: "xxxxxxxxxxxxxxxxxxxxxxxx",
      sender: "xxxxx",
      resendingDelayInSeconds: 30);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var mobileNumberTextField = TextEditingController();
  var codeTextField = TextEditingController();

  String sendingMsg = "";
  String verifyMsg = "";

  bool isErrorSending = false;
  bool isErrorVerify = false;
  bool isVerified = false;

  @override
  void initState() {
    mobileNumberTextField.text = "+971527827667";
    super.initState();
  }

  send() async {
    if (mobileNumberTextField.text.trim().isEmpty) return;
    //send OTP by using mobile number
    //set channel, default = Channel.voice
    ReleansResult result = await ReleansVerify()
        .sendCode(mobile: mobileNumberTextField.text.trim());
    //print message
    log("message ${result.message}");
    //print status code
    log("status ${result.status}");
    //check request is success
    log("isSuccess ${result.isSuccess()}");
    setState(() {
      sendingMsg = result.message!;
      isErrorSending = !result.isSuccess();
    });
  }

  verify() async {
    if (mobileNumberTextField.text.trim().isEmpty ||
        codeTextField.text.trim().isEmpty) return;
    //verify code by using user entered code and mobile number
    ReleansResult result = await ReleansVerify().verifyCode(
        code: codeTextField.text.trim(),
        mobile: mobileNumberTextField.text.trim());
    //print message
    log("message ${result.message}");
    //print status code
    log("status ${result.status}");
    //check request is success
    log("isSuccess ${result.isSuccess()}");
    setState(() {
      verifyMsg = result.message!;
      isErrorVerify = !result.isSuccess();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Releans Verify'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: mobileNumberTextField,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      hintText: 'Mobile Number',
                    ),
                  )),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: send,
                    child: const Text("Send"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder<int>(
                      valueListenable: ReleansVerify().remainingSeconds,
                      builder: (context, value, _) {
                        return Text("remaining $value sec");
                      }),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      ReleansVerify().disposeTimer();
                    },
                    child: const Text("Cancel Timer"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  sendingMsg,
                  style: TextStyle(
                      color: isErrorSending ? Colors.red : Colors.green),
                ),
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: codeTextField,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      hintText: 'Code',
                    ),
                  )),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: verify,
                    child: const Text("Verify"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  verifyMsg,
                  style: TextStyle(
                      color: isErrorVerify ? Colors.red : Colors.green),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isVerified ? "Verified" : "Unverified"),
                  Icon(isVerified
                      ? Icons.verified_user
                      : Icons.verified_user_outlined),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
