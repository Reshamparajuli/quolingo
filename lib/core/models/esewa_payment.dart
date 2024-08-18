import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:finalproject/core/widgets/custom_dialogue.dart';
import 'package:flutter/widgets.dart';

const String _CLIENT_ID = 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R';
const String _SECRET_KEY = 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==';

class PayWithEsewa {
  final totalPriceToShow = 0;

  static Future<bool> makePayment(String totalAmount, BuildContext context) async {
    Completer<bool> paymentCompleter = Completer<bool>();

    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: _CLIENT_ID,
          secretId: _SECRET_KEY,
        ),
        esewaPayment: EsewaPayment(
          productId: '1d71jd81',
          productName: 'Product One',
          productPrice: totalAmount,
          callbackUrl: '',
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult data) async {
          paymentCompleter.complete(true);
          log(':::SUCCESS::: => $data');
          await showCustomSuccessDialogue(context: context, title: 'Payment Successful for NPR $totalAmount');
        },
        onPaymentFailure: (data) {
          log(':::FAILURE::: => $data');
          paymentCompleter.complete(false);
        },
        onPaymentCancellation: (data) {
          log(':::CANCELLATION::: => $data');
          paymentCompleter.complete(false);
        },
      );
    } on Exception catch (e) {
      log('EXCEPTION : ${e.toString()}');
      paymentCompleter.complete(false);
    }

    return paymentCompleter.future;
  }

  static void verifyTransactionStatus(EsewaPaymentSuccessResult result) async {
    log('Verify payment');
  }
}
