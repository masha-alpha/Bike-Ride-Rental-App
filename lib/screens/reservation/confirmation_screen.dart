import 'package:bikeapp_v0/screens/home/home_screen.dart';
import 'package:bikeapp_v0/utils/config.dart';
import 'package:flutter/material.dart';

import '../../utils/next_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: app_bar(context, "Reservation complete"),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Your reservation is complete. You can now collect your bike",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  nextScreen(context, const HomeScreen());
                },
                child: const Text(
                  "Return to home page",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
