import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/member.dart';
import '../utils/app_colors.dart';
import '../utils/keys.dart';
import '../widgets/loading_dialog.dart';
import '../models/login_request.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

import '../utils/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GetStorage _getStorage = GetStorage(Constants.userContainer);

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(title: const Text(Constants.appName)),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: orientation == Orientation.portrait ? width * 0.65 : height * 0.6,
                child: Center(
                  child: ClipOval(
                    child: Image(
                      image: const AssetImage(Assets.logo),
                      width: orientation == Orientation.portrait ? width * 0.55 : height * 0.5,
                      height: orientation == Orientation.portrait ? width * 0.55 : height * 0.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: _mobileNumberController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'Mobile No',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mobile No is Required!!';
                    }
                    if (value.length != 10) {
                      return 'Mobile no must be 10 digits long!!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_showPassword,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _showPassword = !_showPassword),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is Required!!';
                    }
                    return null;
                  },
                ),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: TextButton(
                    onPressed: null,
                    child: Text(
                      'FORGOT PASSWORD?',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  icon: const Icon(Icons.login),
                  label: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid Form
      return;
    }

    Get.dialog(const LoadingDialog(text: 'Logging In...'));

    final mobileNumber = _mobileNumberController.value.text;
    final password = _passwordController.value.text;

    AuthService().login(LoginRequest(mobileNumber, password)).then((result) {
      if (!result.isError) {
        Member? member = result.data;
        if (member != null) {
          _getStorage.write(Keys.loggedInStatus, true);
          _getStorage.write(Keys.loggedInMember, member.toMap());
        }

        Get.offAll(() => const HomeScreen());
      } else {
        Get.back();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 2000),
          ));
        }
      }
    });
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
