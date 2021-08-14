import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info"),
        centerTitle: true,
      ),
      body: const Text(
          "היי חברים זה האפליקציה שלי, ליאל בייגל, כן כמו החטיף וכמו הלחם, והכנתי את האפליקציה הזו סתם לכיף"),
    );
  }
}
