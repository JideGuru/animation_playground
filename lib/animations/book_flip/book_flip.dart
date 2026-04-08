import 'dart:math' as math;

import 'package:flutter/material.dart';

class PageFlipPage extends StatelessWidget {
  const PageFlipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color for the whole screen
      backgroundColor: Colors.blue.shade700,
      body: const Center(
        // Center the card on the screen
        child: FlipCardWidget(),
      ),
    );
  }
}

class FlipCardWidget extends StatefulWidget {
  const FlipCardWidget({super.key});

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: math.pi)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 180,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final isFront = _animation.value < math.pi / 2;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(_animation.value),
                    child: isFront
                        ? _buildPage("Front", Colors.white, Colors.blue)
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(math.pi),
                            child:
                                _buildPage("Back", Colors.blue, Colors.white),
                          ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Set the Stage",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.calendar_today, size: 28),
                Icon(Icons.group, size: 28),
                Icon(Icons.assignment, size: 28),
                Icon(Icons.timer, size: 28),
                Icon(Icons.done_all, size: 28),
              ],
            ),
            const SizedBox(height: 10),
            const Text.rich(
              TextSpan(
                text:
                    "It’s time to assemble a team, find a three-hour block on the calendar, set the ground rules, and assign some optional homework (which is the best kind of homework). But first, should you even run a Brand Sprint at all? ",
                style: TextStyle(fontSize: 13),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: const Text("Set the ground rules"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String text, Color bg, Color fg) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [BoxShadow(blurRadius: 6, offset: Offset(2, 2))],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(color: fg, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
