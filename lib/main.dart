import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'utils/app_colors.dart';
import 'utils/constants.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init(Constants.userContainer);
  await GetStorage.init(Constants.cacheContainer);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Constants.appName,
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

ThemeData theme = ThemeData(
  colorScheme: const ColorScheme.light(),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
    ),
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
    ),
  ),
  useMaterial3: true,
);
