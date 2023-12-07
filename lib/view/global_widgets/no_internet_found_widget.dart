import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:polaris_assignment/core/helpers/widgets_and_attributes.dart';

class NoInternetFoundWidget extends StatefulWidget {
  static final ValueNotifier<bool> isVisible = ValueNotifier<bool>(true);
  const NoInternetFoundWidget({super.key});

  @override
  State<NoInternetFoundWidget> createState() => _NoInternetFoundWidgetState();
}

class _NoInternetFoundWidgetState extends State<NoInternetFoundWidget> {
  @override
  void initState() {
    checkForInternetConnectivity();
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet) {
        NoInternetFoundWidget.isVisible.value = true;
      } else {
        NoInternetFoundWidget.isVisible.value = false;
      }
    });
    super.initState();
  }

  void checkForInternetConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet) {
      NoInternetFoundWidget.isVisible.value = true;
    } else {
      NoInternetFoundWidget.isVisible.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: NoInternetFoundWidget.isVisible,
      builder: (context, isOnline, child) {
        if (!isOnline) {
          return Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red.shade100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  color: Colors.white,
                ),
                sizedBoxW12,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("You need Internet to proceed",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.red.shade600)),
                    sizedBoxH8,
                    const Text(
                      "Please check your connection and try again",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF8694AC)),
                    ),
                  ],
                )
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
