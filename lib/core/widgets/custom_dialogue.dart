import 'package:finalproject/features/pricing/presentation/view/pricing_view.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

Future<bool> showCustomDialogue({
  required BuildContext context,
  String? title,
  String? content,
  String? falseButtonText,
  String? trueButtonText,
  bool reverseButtonPosition = false,
}) async =>
    await showDialog(
      context: context,
      builder: (context) {
        final thm = Theme.of(context);
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Dialog(
              insetPadding: const EdgeInsets.all(16.0),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title ?? "Are you sure?", textAlign: TextAlign.center),
                    const SizedBox(height: 4.0),
                    Text(
                      content ?? "You won't be able to undo this action",
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 8.0),
                    Row(
                      textDirection: reverseButtonPosition ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(falseButtonText ?? "No"),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: thm.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(trueButtonText ?? "Yes"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ) ??
    false;

Future<bool> showCustomSuccessDialogue({
  required BuildContext context,
  String? title,
}) async =>
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Payment Successfull"),
          content: Text(title ?? "Your payment has been successfully processed"),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

Widget showCustomPremiumDialogue({
  required BuildContext context,
  String? title,
}) =>
    AlertDialog(
      backgroundColor: Colors.grey.withOpacity(0.9),
      title: const Text("You are not a premium user"),
      content: Text(title ?? "Please upgrade to premium to access this feature"),
      actions: const <Widget>[],
    );
