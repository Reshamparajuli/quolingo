// ignore_for_file: constant_identifier_names
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

  static makePayment(String totalAmount, BuildContext context) {
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
          log(':::SUCCESS::: => $data');
          // verifyTransactionStatus(data);
          await showCustomSuccessDialogue(context: context, title: 'Payment Successful for NPR $totalAmount');
        },
        onPaymentFailure: (data) {
          log(':::FAILURE::: => $data');
        },
        onPaymentCancellation: (data) {
          log(':::CANCELLATION::: => $data');
        },
      );
    } on Exception catch (e) {
      log('EXCEPTION : ${e.toString()}');
    }
  }

  static void verifyTransactionStatus(EsewaPaymentSuccessResult result) async {
    log('Verify payment');
  }
}
