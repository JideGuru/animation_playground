import 'dart:math';

import 'package:animation_playground/utils.dart';
import 'package:flutter/material.dart';

class RainAnimation extends StatelessWidget {
  const RainAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          for (int index = 0; index < 500; index++)
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

class _RainDropState extends State<_RainDrop> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  late double dx, dy, length, z;
  bool isVisible = true;

  Random random = Random();

  double get screenHeight => widget.screenHeight;

  double get screenWidth => widget.screenWidth;

  @override
  void initState() {
    super.initState();
    dx = random.nextDouble() * screenWidth;
    dy = -500 - (random.nextDouble() * -100);
    z = random.nextDouble() * 20;
    length = rangeMap(z, 0, 20, 10, 20);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: rangeMap(z, 0, 20, 500, 3000).toInt()),
    );
    animation = Tween<double>(begin: dy, end: screenHeight).animate(
      animationController,
    );
    animationController.forward();

    animationController.addListener(animationListener);
  }

  animationListener() {
    if (animationController.status == AnimationStatus.completed) {
      isVisible = false;
      setState(() {});
      animationController.reset();
      z = random.nextDouble() * 20;
      length = rangeMap(z, 0, 20, 10, 20);
      animationController.duration = Duration(
        milliseconds: rangeMap(z, 0, 20, 500, 3000).toInt(),
      );
      dx = random.nextDouble() * screenWidth;
      dy = -500 - (random.nextDouble() * -100);
      setState(() {});
      isVisible = true;
      if (mounted) animationController.forward();
    }
  }

  @override
  void dispose() {
    animationController.removeListener(animationListener);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(dx, animation.value),
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
        },
      ),
    );
  }
}
