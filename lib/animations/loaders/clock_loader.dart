import 'dart:math' as math;

import 'package:flutter/material.dart';

class ClockLoader extends StatefulWidget {
  const ClockLoader({Key? key}) : super(key: key);

  @override
  State<ClockLoader> createState() => _ClockLoaderState();
}

class _ClockLoaderState extends State<ClockLoader>
    with TickerProviderStateMixin {
  static const tickLength = 12;
  static const squareSize = 12.0;
  List<int> colors = List.generate(tickLength, (index) => index);
  late Animation tickAnimation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )
      ..forward()..repeat();
    tickAnimation = Tween<double>(
      begin: 0,
      end: 4 * math.pi,
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    animationController.addListener(() {
      if (animationController.isAnimating) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const offsetAngle = (2 * math.pi) / tickLength;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock Loader'),
      ),
      body: Center(
        child: Stack(
          children: [
            ...colors.map<Widget>((e) {
              int index = colors.indexOf(e);
              final finalAngle = offsetAngle * (tickLength - 1 - index);
              double rotate = () {
                if (tickAnimation.value <= 2 * math.pi) {
                  return math.min<double>(finalAngle, tickAnimation.value);
                }
                if (tickAnimation.value - 2 * math.pi < finalAngle) {
                  return finalAngle;
                }

                return tickAnimation.value;
              }();
              double yDefaultPosition = -index * squareSize;
              double translateY = () {
                if (rotate == finalAngle) {
                  return -tickLength * squareSize;
                }

                if (tickAnimation.value > 2 * math.pi) {
                  return (index - tickLength) * squareSize;
                }

                return yDefaultPosition;
              }();
              return TweenAnimationBuilder(
                tween: Tween<double>(
                  begin: yDefaultPosition,
                  end: translateY,
                ),
                duration: const Duration(milliseconds: 500),
                builder: (context, translateYAnimValue, _) {
                  return Transform.rotate(
                    angle: rotate,
                    child: Transform.translate(
                      offset: Offset(0.0, translateYAnimValue),
                      child: Container(
                        height: squareSize,
                        width: squareSize,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
