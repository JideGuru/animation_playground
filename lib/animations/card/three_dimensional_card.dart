import 'package:flutter/material.dart';

class ThreeDimensionalCard extends StatefulWidget {
  const ThreeDimensionalCard({Key? key}) : super(key: key);

  @override
  State<ThreeDimensionalCard> createState() => _ThreeDimensionalCardState();
}

class _ThreeDimensionalCardState extends State<ThreeDimensionalCard> {
  Offset location = Offset.zero;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    const height = 256.0;
    final width = screenSize.width > 400 ? 400.0 : screenSize.width * 0.9;

    const cardHeight = height - 7;
    final cardWidth = width - 7;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 256,
                width: width,
                decoration: BoxDecoration(
                  gradient: const SweepGradient(colors: [
                    Colors.cyanAccent,
                    Colors.pinkAccent,
                    Colors.yellowAccent,
                    Colors.cyanAccent
                  ]),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002) // perspective
                  ..rotateX(0.001 * location.dy)
                  ..rotateY(-0.001 * location.dx),
                alignment: FractionalOffset.center,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    location += details.delta;
                    setState(() {});
                  },
                  onPanEnd: (details) {
                    location = Offset.zero;
                    setState(() {});
                  },
                  child: Container(
                    height: cardHeight,
                    width: cardWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                    ),
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 20,
                                width: 80 * 2,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 20,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
