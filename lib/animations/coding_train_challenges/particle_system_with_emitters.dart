import 'package:animation_playground/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ParticleSystemWithEmitters extends StatefulWidget {
  const ParticleSystemWithEmitters({Key? key}) : super(key: key);

  @override
  State<ParticleSystemWithEmitters> createState() =>
      _ParticleSystemWithEmittersState();
}

class _ParticleSystemWithEmittersState extends State<ParticleSystemWithEmitters>
    with SingleTickerProviderStateMixin {
  late List<Emitter> emitters;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    emitters = List.empty(growable: true);
    _ticker = createTicker((elapsed) {
      setState(() {});
    });
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          if (emitters.length < 38) {
            emitters.add(Emitter(position: details.globalPosition));
          }
        },
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: CustomPaint(
            painter: _ParticlePainter(
              emitters: emitters,
            ),
          ),
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Emitter> emitters;

  _ParticlePainter({
    required this.emitters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var emitter in emitters) {
      emitter.update();
      for (var particle in emitter.particles) {
        particle.update();
        canvas.drawCircle(
          Offset(particle.x, particle.y),
          10,
          Paint()
            ..color = Color.fromARGB(
              particle.alpha,
              255,
              255,
              255,
            ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  double x, y;
  double vx = doubleInRange(-1, 1);
  double vy = doubleInRange(5, 1);
  int alpha = 255;

  Particle({
    required this.x,
    required this.y,
  });

  update() {
    x += vx;
    y += vy;
    alpha -= 5;
  }

  bool finished() {
    return alpha <= 0;
  }
}

class Emitter {
  final Offset position;
  List<Particle> particles;
  List<Particle> particlesToRemove = List.empty(growable: true);

  Emitter({required this.position})
      : particles = List.generate(
    1,
        (index) => Particle(
      x: position.dx,
      y: position.dy,
    ),
  );

  update() {
    particles.add(Particle(x: position.dx, y: position.dy));
    for (var particle in particles) {
      if (particle.finished()) particlesToRemove.add(particle);
    }

    for (var particle in particlesToRemove) {
      particles.remove(particle);
    }
  }
}
