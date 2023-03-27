import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/scheduler.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart' show rootBundle;

class PaintingWithPixels extends StatefulWidget {
  const PaintingWithPixels({Key? key}) : super(key: key);

  @override
  State<PaintingWithPixels> createState() => _PaintingWithPixelsState();
}

class _PaintingWithPixelsState extends State<PaintingWithPixels>
    with SingleTickerProviderStateMixin {
  late ui.Image image;
  late img.Image imagePixels;
  bool _loading = true;
  List<Offset> offsets = List.empty(growable: true);
  final math.Random _random = math.Random();
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    loadImage();
    _ticker = createTicker((elapsed) {
      if (!_loading) {
        for (int i = 1; i < 100; i++) {
          randomizePoints();
        }
      }
      setState(() {});
    });
    _ticker.start();
  }

  void loadImage() async {
    var data = await rootBundle.load('assets/images/cat.jpeg');
    final buffer = data.buffer;
    var bytes = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    image = await decodeImageFromList(bytes);
    imagePixels = img.decodeJpg(bytes)!;
    _loading = false;
    randomizePoints();
    setState(() {});
  }

  randomizePoints() {
    int x = _random.nextInt(imagePixels.width);
    int y = _random.nextInt(imagePixels.height);

    Offset offset = Offset(x.toDouble(), y.toDouble());
    if (!offsets.contains(offset)) {
      offsets.add(offset);
    } else {
      randomizePoints();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Painting With Pixels')),
      backgroundColor: Colors.white,
      body: _loading
          ? const SizedBox.shrink()
          : Center(
            child: CustomPaint(
                painter: _PixelPainter(
                  image: image,
                  imagePixels: imagePixels,
                  offsets: offsets,
                ),
                child: SizedBox(height: size.height, width: size.width),
              ),
          ),
    );
  }
}

class _PixelPainter extends CustomPainter {
  ui.Image image;
  img.Image imagePixels;
  final List<Offset> offsets;

  _PixelPainter({
    required this.image,
    required this.imagePixels,
    required this.offsets,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawImage(image, Offset.zero, Paint());
    // for (int x = 0; x < imagePixels.width; x++) {
    //   for (int y = 0; y < imagePixels.height; y++) {
    //     img.Pixel pixel = imagePixels.getPixelSafe(x, y);
    //     List colorList = pixel.toList();
    //     canvas.drawCircle(
    //       Offset(x.toDouble(), y.toDouble()),
    //       3,
    //       Paint()..color = Color.fromARGB(255, colorList[0], colorList[1], colorList[2]),
    //     );
    //   }
    // }

    for (Offset offset in offsets) {
      img.Pixel pixel =
          imagePixels.getPixelSafe(offset.dx.toInt(), offset.dy.toInt());
      List colorList = pixel.toList();
      canvas.drawCircle(
        offset,
        3,
        Paint()
          ..color =
              Color.fromARGB(255, colorList[0], colorList[1], colorList[2]),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
