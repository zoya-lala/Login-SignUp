import 'dart:convert';
import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_signup/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // Unique ID on Android
    }
    return '';
  }

  Future<void> createAccount() async {
    try {
      var deviceId = await _getId();
      var deviceType = Platform.operatingSystem;

      var response = await http.post(
        Uri.parse('https://staging.qtamer.qalbit.in/api/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'full_name': fullNameController.text,
          'email': emailController.text,
          'contact': phoneController.text,
          'country_code': '+91',
          'country_name': 'IND',
          'password': passwordController.text,
          'is_user': '0',
          'fcm_token': 'qjkuj564hjbjbsd',
          'device_id': await _getId(),
          'device_type': Platform.operatingSystem,
          'timezone': 'bghvhjhj',
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create account: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred during sign up: $e')),
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
            Text("Create Account",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            Text('Please sign up to make your queue easily',
                style: TextStyle(color: Colors.grey)),
            TextField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: 'Full Name')),
            TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone No.')),
            TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 20.0),
            TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password')),
            MaterialButton(
              color: Colors.orange,
              minWidth: MediaQuery.of(context).size.width,
              onPressed: createAccount,
              child: Text('Sign Up'),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey)),
                Text(' Sign Up with Socials '),
                Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.facebook),
                    SizedBox(width: 5),
                    Text('Facebook'),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.facebook,
                    ),
                    SizedBox(width: 5),
                    Text('Google'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {},
              color: Colors.orange,
              child: Text('Browse Business'),
            ),
            SizedBox(height: 10.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Already have an account?'),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text('Sign In', style: TextStyle(color: Colors.amber)),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
