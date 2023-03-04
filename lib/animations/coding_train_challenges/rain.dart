import 'dart:math';

import 'package:animation_playground/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RainAnimation extends StatelessWidget {
  const RainAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          for (int index = 0; index < 200; index++)
            _RainDrop(
              screenHeight: screenSize.height,
              screenWidth: screenSize.width,
            ),
        ],
      ),
    );
  }
}

class _RainDrop extends StatefulWidget {
  final double screenHeight, screenWidth;

  const _RainDrop({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  State<_RainDrop> createState() => _RainDropState();
}

class _RainDropState extends State<_RainDrop> with SingleTickerProviderStateMixin {
  // vy(velocity Y) for the speed on the yAxis
  late double dx, dy, length, z, vy;

  Random random = Random();
  double get screenHeight => widget.screenHeight;

  double get screenWidth => widget.screenWidth;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    randomizeValues();
    _ticker = createTicker((elapsed) {
      dy += vy;
      if (dy >= screenHeight + 100) {
        randomizeValues();
      }
      setState(() {});
    });
    _ticker.start();
  }

  randomizeValues() {
    dx = random.nextDouble() * screenWidth;
    dy = -500 - (random.nextDouble() * -500);
    z = random.nextDouble() * 20;
    length = rangeMap(z, 0, 20, 10, 20);
    vy = rangeMap(z, 0, 20, 15, 5);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Container(
        height: length,
        width: 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(width: rangeMap(z, 0, 20, 1, 3)),
        ),
      ),
    );
  }
}
