import 'dart:async';
import 'package:bikeapp_v0/provider/sign_in_provider.dart';
import 'package:bikeapp_v0/screens/home/home_screen.dart';
import 'package:bikeapp_v0/screens/auth/login_screen.dart';
import 'package:bikeapp_v0/utils/config.dart';
import 'package:bikeapp_v0/utils/next_screen.dart';
import 'package:bikeapp_v0/utils/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;

  User? user = FirebaseAuth.instance.currentUser;
  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  Timer? timer;

  @override
  void initState() {
    isEmailVerified = user!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 4),
        (_) => checkEmailVerified(),
      );
    }
    super.initState();
    getData();
  }

  @override
  @mustCallSuper
  // ignore: must_call_super
  void dispose() {
    timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      await user!.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 15));
      setState(() => canResendEmail = true);
    } catch (e) {
      openSnackbar(context, e.toString(), Colors.red);
    }
  }

  Future checkEmailVerified() async {
    await user!.reload();
    setState(() {
      isEmailVerified = user!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
    if (isEmailVerified) {
      return const HomeScreen();
    } else {
      return Scaffold(
        appBar: app_bar(context, "Verify you email !"),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "A verification email has been sent to ${user!.email}",
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(
                    Icons.email,
                    size: 32,
                  ),
                  label: const Text(
                    "Resend email",
                    style: TextStyle(fontSize: 22),
                  ),
                  onPressed: canResendEmail ? sendVerificationEmail : null),
              const SizedBox(height: 14),
              TextButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  "I have verified my email",
                  style: TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  sp.userSignOut();
                  nextScreen(context, const LoginScreen());
                },
              ),
              const SizedBox(height: 14),
              TextButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  sp.userSignOut();
                  nextScreen(context, const LoginScreen());
                },
              )
            ],
          ),
        ),
      );
    }
  }
}
