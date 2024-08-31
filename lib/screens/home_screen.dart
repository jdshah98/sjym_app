import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sjym_app/models/member.dart';
import 'package:sjym_app/screens/login_screen.dart';
import 'package:sjym_app/utils/constants.dart';
import 'package:sjym_app/utils/keys.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetStorage _getStorage = GetStorage(Constants.userContainer);

  Member? _loggedInMember;

  @override
  void initState() {
    super.initState();
    _loggedInMember = _getStorage.read<Member>(Keys.loggedInMember);
    if (_loggedInMember == null) {
      _getStorage.erase();

      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Constants.appName)),
      body: Center(
        child: Text("hello ${_loggedInMember!.name.toString()}"),
      ),
    );
  }
}
