import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class MetaballFAB extends StatefulWidget {
  const MetaballFAB({Key? key}) : super(key: key);

  @override
  State<MetaballFAB> createState() => _MetaballFABState();
}

class _MetaballFABState extends State<MetaballFAB>
    with TickerProviderStateMixin {
  late Offset mainButtonPos;
  late Offset firstButtonPos;
  late Offset secondButtonPos;
  late final AnimationController _firstController;
  late Animation<Offset> _firstAnimation;
  late final AnimationController _secondController;
  late Animation<Offset> _secondAnimation;
  bool expanded = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _firstController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _secondController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _firstController.addListener(() {
      setState(() {});
    });
    _secondController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final size = MediaQuery.of(context).size;
      final screenWidth = size.width;
      final screenHeight = size.height;
      mainButtonPos = Offset(screenWidth / 2, screenHeight - 100);
      firstButtonPos = Offset(screenWidth / 2, screenHeight - 100);
      secondButtonPos = Offset(screenWidth / 2, screenHeight - 100);

      _firstAnimation = Tween<Offset>(
        begin: firstButtonPos,
        end: Offset(firstButtonPos.dx, firstButtonPos.dy - 250),
      ).animate(_firstController);

      _secondAnimation = Tween<Offset>(
        begin: secondButtonPos,
        end: Offset(secondButtonPos.dx, secondButtonPos.dy - 140),
      ).animate(_secondController);

      _initialized = true;
    }
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const SizedBox.shrink();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metaball FAB'),
      ),
      backgroundColor: Colors.black,
      body: ShaderBuilder(
        assetKey: 'shaders/metaball_shader.frag',
        child: Stack(
          children: [
            Positioned(
              top: firstButtonPos.dy,
              left: firstButtonPos.dx,
              child: Container(
                height: 40,
                width: 40,
                color: Colors.transparent,
              ),
            ),
            Positioned(
              top: mainButtonPos.dy - 100,
              left: mainButtonPos.dx - 90,
              child: GestureDetector(
                onTap: () {
                  if (expanded) {
                    _firstController.reverse();
                    _secondController.reverse();
                  } else {
                    _firstController.forward();
                    _secondController.forward();
                  }
                  expanded = !expanded;
                },
                child: Container(
                  height: 150,
                  width: 150,
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
        (context, shader, child) {
          return AnimatedSampler(
            child: child!,
            (ui.Image image, Size size, Canvas canvas) {
              shader
                ..setFloat(0, mainButtonPos.dx)
                ..setFloat(1, mainButtonPos.dy)
                ..setFloat(2, 90)
                ..setFloat(3, _firstAnimation.value.dx)
                ..setFloat(4, _firstAnimation.value.dy)
                ..setFloat(5, 40)
                ..setFloat(6, 3)
                ..setFloat(7, 1.9)
                ..setFloat(8, 10.0)
                ..setFloat(9, _secondAnimation.value.dx)
                ..setFloat(10, _secondAnimation.value.dy)
                ..setFloat(11, 40);
              canvas.drawRect(
                Offset.zero & size,
                Paint()
                  ..color = Colors.white
                  ..shader = shader,
              );
            },
          );
        },
      ),
    );
  }
}
