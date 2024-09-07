import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sjym_app/screens/home_screen.dart';
import 'package:sjym_app/screens/login_screen.dart';
import 'package:sjym_app/services/advertisement_service.dart';
import 'package:sjym_app/utils/assets.dart';
import 'package:sjym_app/utils/constants.dart';
import 'package:sjym_app/utils/keys.dart';
import 'package:sjym_app/widgets/loading_widget.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen({super.key});

  @override
  State<AdvertisementScreen> createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  static const int _timeout = 10;
  bool _isLoaded = false;
  String _advertisementPath = '';

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    AdvertisementService().getWelcomeAdvertisementPath().then((result) {
      if (mounted) {
        setState(() {
          _advertisementPath = result ?? '';
          _isLoaded = true;
        });

        _timer = Timer(const Duration(seconds: _timeout), () {
          if (mounted) {
            _navigateToNextScreen();
          }
        });
      }
    }).catchError((err) {
      debugPrint('Error: ${err.toString()}');
      log(err.toString(), error: err, name: runtimeType.toString());
      _navigateToNextScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const LoadingWidget(text: 'Loading...');
    }
    return Scaffold(
      body: Center(
        child: Image(
          image: _advertisementPath.isNotEmpty
              ? FileImage(File(_advertisementPath)) as ImageProvider<Object>
              : const AssetImage(Assets.defaultAdvertisement),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
      floatingActionButton: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: FloatingActionButton.small(
                onPressed: () => _navigateToNextScreen(),
                backgroundColor: Colors.red,
                child: const Icon(Icons.close, color: Colors.white),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  _navigateToNextScreen() {
    if (_timer != null) {
      _timer!.cancel();
    }

    bool isLoggedIn = GetStorage(Constants.userContainer).read<bool>(Keys.loggedInStatus) ?? false;
    if (isLoggedIn) {
      Get.off(const HomeScreen());
    } else {
      Get.off(const LoginScreen());
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }
}
