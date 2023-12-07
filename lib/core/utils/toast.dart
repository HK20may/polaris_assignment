import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:polaris_assignment/core/helpers/widgets_and_attributes.dart';
import 'package:polaris_assignment/core/utils/routes/route_helper.dart';

class Toast {
  static final FToast fToast = FToast();
  static void init() {
    fToast.init(RouteHelper.navigatorContext);
  }

  static void info(String msg) {
    _buildCustomToast(msg, Colors.black87);
  }

  static void error([String errorMsg = "Oops! Try Again."]) {
    _buildCustomToast(errorMsg, Colors.black87, isErrorType: true);
  }

  static void _buildCustomToast(String msg, Color bgColor,
      {bool isErrorType = false}) {
    fToast.showToast(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: bgColor,
              boxShadow: const [
                BoxShadow(
                    blurRadius: 10, spreadRadius: 4, color: Colors.black26)
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: isErrorType
                      ? const Color(0xFFF33636)
                      : const Color(0xFF8ADB7D),
                ),
                sizedBoxW10,
                Expanded(
                  child: Text(
                    msg,
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xFF9B9B9B)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      toastDuration: Duration(seconds: _getToastDuration(msg)),
    );
  }

  static int _getToastDuration(String msg) {
    int toastDuration = msg.length ~/ 20;

    if (toastDuration < 2) {
      toastDuration = 2;
    } else if (toastDuration > 8) {
      toastDuration = 8;
    }
    return toastDuration;
  }
}
