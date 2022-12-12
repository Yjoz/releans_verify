# releans_verify

In this plugin, you can send and verify OTP through releans API

## import

```dart
import 'package:releans_verify/releans.dart';
```


## init releans
- copy API key from releans dashboard and set the apiKey
- create sender from releans dashboard and set the sender
- set resending delay in seconds, default delay is 15 seconds

```dart
void main() async {
  ReleansVerify().init(
      apiKey: "XXXXXXXXXXXXXXXXX",
      sender: "XXXXXXXXX",
      resendingDelayInSeconds: 30
  );
  
  runApp(MyApp());
}
```


## send OTP
- call sendCode with mobile number
- mobile number should contain the country code
- specify channel (default is sms)

```dart
  ReleansResult result =
  await ReleansVerify().sendCode(mobile: "+9715200000");

  ReleansResult result = await ReleansVerify()
    .sendCode(mobile:"+9715200000",channel: Channel.voice);
```

## listen to remaining count down time
- listen to ReleansVerify().remainingSeconds for showing remaining seconds
- if you want to cancel timer manually call disposeTimer()


```dart
  ValueListenableBuilder<int>(
        valueListenable: ReleansVerify().remainingSeconds,
        builder: (context, value, _) {
        return Text("resend after $value sec");
  }),

  ReleansVerify().disposeTimer();
```

## verify OTP
- call verifyCode with user entered code and mobile number


```dart
 ReleansResult result = await ReleansVerify().verifyCode(
                          code: "0000", mobile:"+9715200000");
```

## handle result
- ReleansResult object will return after sendCode and verifyCode methods
- view response message by using reult.message 
- check request is success by using result.isSuccess()

```dart
    //print message
    log("message ${result.message}");
    //print status code
    log("status ${result.status}");
    //check request is success
    log("isSuccess ${result.isSuccess()}");
```

## Authors

* [Yjoz General Trading L.L.C](https://yjoz.com)