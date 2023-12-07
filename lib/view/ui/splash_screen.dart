import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:polaris_assignment/core/helpers/app_assets_path.dart';
import 'package:polaris_assignment/core/utils/routes/route_helper.dart';
import 'package:polaris_assignment/core/utils/routes/routes.dart';
import 'package:polaris_assignment/core/utils/toast.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    Toast.init();
    _animationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 50),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(4, 4, 104, 1),
                Color.fromRGBO(20, 16, 170, 1),
                Color.fromRGBO(4, 2, 104, 1),
              ]),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // alignment: Alignment.center,
          children: [
            loadLottie(),
            Flexible(
              child: AnimatedTextKit(
                // repeatForever: true,
                totalRepeatCount: 1,
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText('Polaris',
                      speed: const Duration(milliseconds: 100),
                      textStyle: const TextStyle(
                        fontSize: 36,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadLottie() {
    return Lottie.asset(
      AppAssetsPath.splashLottie,
      controller: _animationController,
      height: 100,
      width: 100,
      fit: BoxFit.scaleDown,
      animate: true,
      onLoaded: ((composition) {
        _animationController
          ..duration = composition.duration
          ..forward()
              // .timeout(const Duration(milliseconds: 4000))
              .whenComplete(() {
            return RouteHelper.pushReplacement(Routes.HOME);
          });
      }),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
