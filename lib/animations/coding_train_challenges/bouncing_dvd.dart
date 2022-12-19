import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class BouncingDVD extends StatefulWidget {
  const BouncingDVD({Key? key}) : super(key: key);

  @override
  State<BouncingDVD> createState() => _BouncingDVDState();
}

class _BouncingDVDState extends State<BouncingDVD> {
  Random random = Random();
  Color dvdColor = Colors.pink;
  double dvdWidth = 150, dvdHeight = 80;
  double x = 90, y = 30, xSpeed = 50, ySpeed = 50, speed = 150;

  pickColor() {
    // removing the timer will make the dvd color change before bouncing
    // off the edge
    Timer(const Duration(milliseconds: 100), () {
      int r = random.nextInt(255);
      int g = random.nextInt(255);
      int b = random.nextInt(255);
      dvdColor = Color.fromRGBO(r, g, b, 1);
    });
  }

  @override
  initState() {
    super.initState();
    update();
  }

  update() {
    Timer.periodic(Duration(milliseconds: speed.toInt()), (timer) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      x += xSpeed;
      y += ySpeed;

      if (x + dvdWidth >= screenWidth) {
        xSpeed = -xSpeed;
        x = screenWidth - dvdWidth;
        pickColor();
      } else if (x <= 0) {
        xSpeed = -xSpeed;
        x = 0;
        pickColor();
      }

      if (y + dvdHeight >= screenHeight) {
        ySpeed = -ySpeed;
        y = screenHeight - dvdHeight;
        pickColor();
      } else if (y <= 0) {
        ySpeed = -ySpeed;
        y = 0;
        pickColor();
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: speed.toInt()),
            left: x,
            top: y,
            child: Image.asset(
              'assets/images/dvd-logo.png',
              color: dvdColor,
              height: dvdHeight,
              width: dvdWidth,
            ),
          ),
        ],
      ),
    );
  }
}
