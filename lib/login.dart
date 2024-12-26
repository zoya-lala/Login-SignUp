import 'dart:convert';
import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_signup/dashboard.dart';
import 'package:login_signup/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor ?? ''; // Unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId ?? ''; // Unique ID on Android
    }
    return '';
  }

  Future<void> loginUser() async {
    try {
      var response = await http.post(
        Uri.parse('https://staging.qtamer.qalbit.in/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': emailController.text,
          'password': passwordController.text,
          'is_user': '0',
          'fcm_token': 'qjkuj564hjbjbsd',
          'device_id': await _getId(),
          'device_type': Platform.operatingSystem,
          'timezone': 'bghvhjhj',
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred during login')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            Text('Please sign in to continue',
                style: TextStyle(color: Colors.grey)),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    Text('Remember Me'),
                  ],
                ),
                Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.amber),
                ),
              ],
            ),
            MaterialButton(
              color: Colors.orange,
              minWidth: MediaQuery.of(context).size.width,
              onPressed: loginUser,
              child: Text('Log In'),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey)),
                Text(' Sign In with Socials '),
                Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.facebook),
                    SizedBox(width: 8),
                    Text('Facebook'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.facebook),
                    SizedBox(width: 8),
                    Text('Google'),
                  ],
                ),
              ],
            ),
            MaterialButton(
              color: Colors.orange,
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {},
              child: Text('Browse Business'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: Text('Sign Up', style: TextStyle(color: Colors.amber)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
