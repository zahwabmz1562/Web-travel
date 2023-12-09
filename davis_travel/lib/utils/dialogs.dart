import 'dart:async';

import 'package:davis_travel/utils/app_colors.dart';
import 'package:davis_travel/widget/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> showAlertDialog(
    {required String title,
    String? content,
    Duration? duration,
    bool barrierDismissible = true}) {
  return showCupertinoDialog<void>(
    context: Get.context!,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return AutoDismissDialog(
        title: title,
        content: content,
        duration: duration,
      );
    },
  );
}

class AutoDismissDialog extends StatefulWidget {
  final String? title;
  final String? content;
  final Duration? duration;

  const AutoDismissDialog({Key? key, this.title, this.content, this.duration})
      : super(key: key);

  @override
  State<AutoDismissDialog> createState() => _AutoDismissDialogState();
}

class _AutoDismissDialogState extends State<AutoDismissDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer when the dialog is first shown
    if (widget.duration != null) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    // Create a timer that triggers after 5 seconds
    _timer = Timer(widget.duration ?? const Duration(seconds: 5), () {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      backgroundColor: colorBgScreen2,
      title: CustomText(
        text: widget.title ?? "information".tr,
        color: colorBlack,
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
      ),
      content: CustomText(
        text: widget.content ?? 'Error',
        color: colorBlack,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
      ),
      actions: <Widget>[
        TextButton(
          child: const CustomText(text: 'OK'),
          onPressed: () {
            HapticFeedback.lightImpact();

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
