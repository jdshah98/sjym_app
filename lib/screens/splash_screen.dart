import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'advertisement_screen.dart';
import '../utils/app_colors.dart';

import '../utils/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;

    // Splash Screen Timer
    Future.delayed(
      const Duration(seconds: 3),
      () => Get.off(() => const AdvertisementScreen()),
    );

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Center(
              child: ClipOval(
                child: Image(
                  image: const AssetImage(Assets.logo),
                  width: shortestSide * 0.6,
                  height: shortestSide * 0.6,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(
            height: shortestSide * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Developed By Jainam Shah',
                  textScaler: MediaQuery.of(context).textScaler,
                  style: Theme.of(context).primaryTextTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
