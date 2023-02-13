import 'dart:math';

import 'package:animation_playground/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SimpleParticleSystem extends StatefulWidget {
  const SimpleParticleSystem({Key? key}) : super(key: key);

  @override
  State<SimpleParticleSystem> createState() => _SimpleParticleSystemState();
}

class _SimpleParticleSystemState extends State<SimpleParticleSystem>
    with SingleTickerProviderStateMixin {
  late List<Particle> particles;
  late List<Particle> particlesToRemove;
  Random random = Random();
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    particles = List.generate(1, (index) => Particle());
    particlesToRemove = List.empty(growable: true);

    _ticker = createTicker((elapsed) {
      particles.add(Particle());
      for (var particle in particlesToRemove) {
        particles.remove(particle);
      }
      setState(() {});
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: ParticlePainter(
          particles: particles,
          particlesToRemove: particlesToRemove,
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  List<Particle> particles;
  List<Particle> particlesToRemove;

  ParticlePainter({required this.particles, required this.particlesToRemove});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.setPosition(particle.x * size.width, particle.y * size.height);
      particle.update();
      var paint = Paint()
        ..color = Colors.white.withOpacity(particle.opacity)
        ..strokeWidth = 3.0;
      canvas.drawCircle(Offset(particle.x, particle.y), 13.0, paint);
      if (particle.finished()) particlesToRemove.add(particle);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Particle {
  double x = 0.5;
  double y = 0.9;
  double vx = doubleInRange(-1, 1);
  double vy = doubleInRange(-5, -1);
  double opacity = 1;

  Particle();

  setPosition(double xPos, double yPos) {
    if (x < 1 && y < 1) {
      x = xPos;
      y = yPos;
    }
  }

  update() {
    x += vx;
    y += vy;
    if (opacity >= 0.1) {
      opacity -= 0.015;
    }
  }

  bool finished() {
    return opacity <= 0.1;
  }
}
